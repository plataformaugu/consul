class ProposalsController < ApplicationController
  include FeatureFlags
  include CommentableActions
  include FlagActions
  include ImageAttributes
  include DocumentAttributes
  include MapLocationAttributes
  include Translatable

  before_action :load_categories, only: [:index, :map, :summary]
  before_action :load_geozones, only: [:edit, :map, :summary]
  before_action :set_color
  before_action :authenticate_user!, except: [:index, :show, :map, :summary, :initiatives]
  before_action :destroy_map_location_association, only: :update
  before_action :set_view, only: :index
  before_action :proposals_recommendations, only: :index, if: :current_user

  feature_flag :proposals

  invisible_captcha only: [:create, :update], honeypot: :subtitle

  has_orders ->(c) { Proposal.proposals_orders(c.current_user) }, only: :index
  has_orders %w[most_voted newest oldest], only: :show

  load_and_authorize_resource
  helper_method :resource_model, :resource_name
  respond_to :html, :js

  def index
    redirect_to root_path

    @proposals = Kaminari.paginate_array(
      @proposals.where(is_initiative: false)).page(params[:page])
  end

  def initiatives
    @proposals = Kaminari.paginate_array(
      @proposals.where(is_initiative: true)).page(params[:page])
  end

  def show
    if @proposal.published_at.nil?
      if current_user and current_user.administrator?
        nil
      else
        redirect_to root_path
      end
    end

    super
    @notifications = @proposal.notifications
    @notifications = @proposal.notifications.not_moderated

    if request.path != proposal_path(@proposal)
      redirect_to proposal_path(@proposal), status: :moved_permanently
    end
  end

  def new
    @is_initiative = params['is_initiative']
    @proposals_theme = ProposalsTheme.find_by_id(params['proposals_theme_id'])

    if @is_initiative and @proposals_theme.present?
      redirect_to '/iniciativas'
    end

    if @proposals_theme.present?
      if Time.now > @proposals_theme.end_date
        redirect_to proposals_themes_path
      end
    end

    if !@is_initiative and @proposals_theme.nil?
      redirect_to proposals_themes_path
    end

    if @is_initiative and !current_user.administrator?
      redirect_to root_path
    end

    super
  end

  def create
    @proposal = Proposal.new(proposal_params.merge(author: current_user, terms_of_service: true))

    if params['proposal']['sector_ids']
      params['proposal']['sector_ids'].each do |s|
        begin
          sector = Sector.find_by(name: s)
          @proposal.sectors.append(sector)
        rescue
        end
      end
    end

    if @proposal.save
      if @proposal.is_initiative
        @proposal.publish
      end

      redirect_to share_proposal_path(@proposal)
    else
      if @proposal.is_initiative
        render :new
      else
        @proposals_theme = ProposalsTheme.find(@proposal.proposals_theme_id)
        render :new
      end
    end
  end

  def created; end

  def index_customization
    discard_draft
    discard_archived
    load_retired
    load_selected
    load_featured
    remove_archived_from_order_links
  end

  def vote
    if @proposal.sectors.any?
      if current_user.sector.nil?
        redirect_to proposal_path(@proposal), alert: 'No perteneces al sector de participación.' and return
      else
        unless @proposal.sectors.pluck(:id).include?(current_user.sector.id)
          redirect_to proposal_path(@proposal), alert: 'No perteneces al sector de participación.' and return
        end
      end
    end

    if @proposal.proposals_theme.present? and !@proposal.proposals_theme.is_public
      if current_user and !current_user.has_tarjeta_vecino
        redirect_to proposal_path(@proposal), alert: 'Necesitas tener Tarjeta Vecino para participar.' and return
      end
    end

    @follow = Follow.find_or_create_by!(user: current_user, followable: @proposal)
    @proposal.register_vote(current_user, "yes")
    set_proposal_votes(@proposal)
    respond_to do |format|
      format.html { redirect_to proposal_path(@proposal.id) }
    end
  end

  def retire
    if @proposal.update(retired_params.merge(retired_at: Time.current))
      redirect_to proposal_path(@proposal), notice: t("proposals.notice.retired")
    else
      render action: :retire_form
    end
  end

  def retire_form
  end

  def vote_featured
    @follow = Follow.find_or_create_by!(user: current_user, followable: @proposal)
    @proposal.register_vote(current_user, "yes")
    set_featured_proposal_votes(@proposal)
  end

  def summary
    @proposals = Proposal.for_summary
    @tag_cloud = tag_cloud
  end

  def disable_recommendations
    if current_user.update(recommended_proposals: false)
      redirect_to proposals_path, notice: t("proposals.index.recommendations.actions.success")
    else
      redirect_to proposals_path, error: t("proposals.index.recommendations.actions.error")
    end
  end

  def publish
    @proposal.publish
    redirect_to moderation_proposals_path, notice: t("proposals.notice.published")
  end

  private

    def proposal_params
      attributes = [:video_url, :responsible_name, :tag_list,
                    :related_sdg_list,
                    :is_initiative,
                    :proposals_theme_id,
                    :main_theme_id,
                    image_attributes: image_attributes,
                    documents_attributes: document_attributes,
                    map_location_attributes: map_location_attributes]
      translations_attributes = translation_params(Proposal, except: :retired_explanation)
      params.require(:proposal).permit(attributes, translations_attributes)
    end

    def retired_params
      attributes = [:retired_reason]
      translations_attributes = translation_params(Proposal, only: :retired_explanation)
      params.require(:proposal).permit(attributes, translations_attributes)
    end

    def resource_model
      Proposal
    end

    def set_featured_proposal_votes(proposals)
      @featured_proposals_votes = current_user ? current_user.proposal_votes(proposals) : {}
    end

    def discard_draft
      @resources = @resources.published
    end

    def discard_archived
      unless @current_order == "archival_date" || params[:selected].present?
        @resources = @resources.not_archived
      end
    end

    def load_retired
      if params[:retired].present?
        @resources = @resources.retired
        @resources = @resources.where(retired_reason: params[:retired]) if Proposal::RETIRE_OPTIONS.include?(params[:retired])
      else
        @resources = @resources.not_retired
      end
    end

    def load_selected
      if params[:selected].present?
        @resources = @resources.selected
      else
        @resources = @resources.not_selected
      end
    end

    def load_featured
      return unless !@advanced_search_terms && @search_terms.blank? && params[:retired].blank? && @current_order != "recommendations"

      if Setting["feature.featured_proposals"]
        @featured_proposals = Proposal.not_archived.unsuccessful
                              .sort_by_confidence_score.limit(Setting["featured_proposals_number"])
        if @featured_proposals.present?
          set_featured_proposal_votes(@featured_proposals)
          @resources = @resources.where.not(id: @featured_proposals)
        end
      end
    end

    def remove_archived_from_order_links
      @valid_orders.delete("archival_date")
    end

    def set_view
      @view = (params[:view] == "minimal") ? "minimal" : "default"
    end

    def destroy_map_location_association
      map_location = params[:proposal][:map_location_attributes]
      if map_location && (map_location[:longitude] && map_location[:latitude]).blank? && !map_location[:id].blank?
        MapLocation.destroy(map_location[:id])
      end
    end

    def proposals_recommendations
      if Setting["feature.user.recommendations_on_proposals"] && current_user.recommended_proposals
        @recommended_proposals = Proposal.recommendations(current_user).sort_by_random.limit(3)
      end
    end

    def set_color
      @color = '#f37969'
    end
end
