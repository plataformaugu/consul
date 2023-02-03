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
  before_action :authenticate_user!, except: [:index, :show, :map, :summary]
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

  def show
    redirect_to "#{url_for(proposal_topics_path)}?proposal=#{@proposal.id}#card-#{@proposal.id}"
  end

  def new
    @proposal_topic = ProposalTopic.find_by_id(params[:proposal_topic_id])

    if !@proposal_topic.present?
      redirect_to root_path
      return
    end

    if not @proposal_topic.is_active?
      redirect_to root_path
    end
  end

  def create
    @proposal = Proposal.new(proposal_params.merge(author: current_user))

    if @proposal.proposal_topic_id.nil?
      flash[:error] = "Ocurrió un error inesperado. Inténtalo nuevamente."
      render :new
    end

    if @proposal.save
      redirect_to pending_proposal_path(@proposal)
    else
      render :new
    end
  end

  def created; end

  def index
    @proposal_topics = ProposalTopic.published.order(created_at: :desc)
    @proposal_topic = ProposalTopic.find_by_id(params[:id])

    if @proposal_topic.present? && @proposal_topic.is_published?
      redirect_to "#{url_for(proposal_topics_path)}?topic=#{@proposal_topic.id}"
    else
      redirect_to root_path
    end
  end

  def index_customization
    discard_draft
    discard_archived
    load_retired
    load_selected
    load_featured
    remove_archived_from_order_links
  end

  def vote
    @follow = Follow.find_or_create_by!(user: current_user, followable: @proposal)
    @proposal.register_vote(current_user, "yes")

    redirect_to "#{url_for(proposal_topics_path)}?proposal=#{@proposal.id}#support-container"
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
    redirect_to moderation_proposals_path, notice: '¡La propuesta ha sido publicada!'
  end

  private

    def proposal_params
      params.require(:proposal).permit(allowed_params)
    end

    def allowed_params
      attributes = [:video_url, :responsible_name, :tag_list,
                    :geozone_id, :related_sdg_list, :proposal_topic_id,
                    image_attributes: image_attributes,
                    documents_attributes: document_attributes,
                    map_location_attributes: map_location_attributes]
      translations_attributes = translation_params(Proposal, except: :retired_explanation)

      [*attributes, translations_attributes]
    end

    def retired_params
      params.require(:proposal).permit(allowed_retired_params)
    end

    def allowed_retired_params
      [:retired_reason, translation_params(Proposal, only: :retired_explanation)]
    end

    def resource_model
      Proposal
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
end
