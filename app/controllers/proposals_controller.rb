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

  invisible_captcha only: [:create], honeypot: :subtitle

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
    @orders = [
      ['Más votadas', 'most_voted'],
      ['Menos votadas', 'least_voted'],
      ['Más recientes', 'newest'],
      ['Más antiguas', 'oldest']
    ]
    @selected_order = params[:order]
    @proposals = sort_by(params)
  end

  def show
    if @proposal.published_at.nil?
      if current_user and (current_user.administrator? or current_user.moderator?)
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

    @can_participate = true
    @reason = nil

    if @proposal.is_initiative
      if current_user && !current_user.administrator? && @proposal.segmentation.present?
        @can_participate, @reason = @proposal.segmentation.validate(current_user)
      end
    else
      if current_user && !current_user.administrator? && @proposal.proposals_theme.segmentation.present?
        @can_participate, @reason = @proposal.proposals_theme.segmentation.validate(current_user)
      end
    end
  end

  def new
    @is_initiative = params['is_initiative']
    @proposals_theme = ProposalsTheme.find_by_id(params['proposals_theme_id'])

    if @is_initiative and @proposals_theme.present?
      redirect_to '/iniciativas'
    end

    if @proposals_theme.present?
      if Time.now.to_date > @proposals_theme.end_date
        redirect_to proposals_themes_path
      end

      if not @proposals_theme.neighbor_types.include?(current_user.neighbor_type) and not current_user.administrator?
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

    if @proposal.save
      if @proposal.is_initiative
        Segmentation.generate(entity_name: @proposal.class.name, entity_id: @proposal.id, params: params)
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

  def update
    if @proposal.update(proposal_params)
      if @proposal.is_initiative
        Segmentation.generate(entity_name: @proposal.class.name, entity_id: @proposal.id, params: params)
      end

      redirect_to @proposal, notice: 'La iniciativa fue actualizada.'
    else
      render :edit
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
    if not @proposal.is_initiative
      if @proposal.proposals_theme.end_date < Time.now.to_date
        redirect_to proposal_path(@proposal) and return
      end

      if @proposal.proposals_theme.sectors.any?
        if !@proposal.proposals_theme.sectors.include?(current_user.sector)
          redirect_to proposal_path(@proposal), alert: 'No perteneces al sector de participación' and return
        end
      end
    else
      if @proposal.sectors.any?
        if current_user.sector.nil?
          redirect_to proposal_path(@proposal), alert: 'No perteneces al sector de participación.' and return
        else
          unless @proposal.sectors.pluck(:id).include?(current_user.sector.id)
            redirect_to proposal_path(@proposal), alert: 'No perteneces al sector de participación.' and return
          end
        end
      end
    end

    @follow = Follow.find_or_create_by!(user: current_user, followable: @proposal)
    @proposal.register_vote(current_user, "yes")
    set_proposal_votes(@proposal)
    respond_to do |format|
      format.html { redirect_to proposal_path(@proposal.id) }
    end
  end

  def down_vote
    if @proposal.proposals_theme.end_date < Time.now.to_date
      redirect_to proposal_path(@proposal) and return
    end

    if @proposal.proposals_theme.sectors.any?
      if !@proposal.proposals_theme.sectors.include?(current_user.sector)
        redirect_to proposal_path(@proposal), alert: 'No perteneces al sector de participación' and return
      end
    end

    @follow = Follow.find_or_create_by!(user: current_user, followable: @proposal)
    @proposal.register_vote(current_user, "no")
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
    Mailer.notify_published_proposal(@proposal).deliver_later
    @proposal.publish
    redirect_to moderation_proposals_path, notice: t("proposals.notice.published")
  end

  def toggle_in_development
    new_value = !@proposal.in_development
    @proposal.in_development = new_value
    @proposal.save!

    if new_value
      message = 'La propuesta ha sido marcada como "En desarrollo"'
    else
      message = 'La propuesta ya no está "En desarrollo"'
    end

    redirect_to @proposal, notice: message
  end

  private

    def proposal_params
      attributes = [:video_url, :responsible_name, :tag_list,
                    :related_sdg_list,
                    :is_initiative,
                    :proposals_theme_id,
                    :main_theme_id,
                    :limit_date,
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
    
    def sort_by(params)
      proposals = @proposals.where(is_initiative: true)
      orders = [
        'most_voted',
        'least_voted',
        'newest',
        'oldest',
      ]

      if params.include?('order') and orders.include?(params[:order])
        case params[:order]
        when 'most_voted'
          proposals = proposals.order(cached_votes_up: :desc)
        when 'least_voted'
          proposals = proposals.order(cached_votes_up: :asc)
        when 'newest'
          proposals = proposals.order(created_at: :desc)
        when 'oldest'
          proposals = proposals.order(created_at: :asc)
        else
          proposals = proposals.order(cached_votes_up: :desc)
        end
      else
        proposals = proposals.order(cached_votes_up: :desc)
      end

      return Kaminari.paginate_array(proposals).page(params[:page])
    end
end
