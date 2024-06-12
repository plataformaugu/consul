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
    super
    @notifications = @proposal.notifications
    @notifications = @proposal.notifications.not_moderated

    if request.path != proposal_path(@proposal)
      redirect_to proposal_path(@proposal), status: :moved_permanently
    end
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
      redirect_to proposal_topics_path
    end

    if @proposal.save
      redirect_to pending_proposal_path(@proposal)
    else
      render :new
    end
  end

  def created; end

  def index
    @proposal_topic = ProposalTopic.find_by_id(params[:id])

    if @proposal_topic.present? && @proposal_topic.is_published?
      super
      @proposals = Proposal.where(proposal_topic_id: @proposal_topic.id).published

      if Setting["feature.featured_proposals"]
        @featured_proposals = @featured_proposals.where(proposal_topic_id: @proposal_topic.id)
      end

      @orders = [
        ['Más votadas', 'most_voted'],
        ['Menos votadas', 'least_voted'],
        ['Más recientes', 'newest'],
        ['Más antiguas', 'oldest']
      ]
      @selected_order = params[:order]
      @proposals = sort_by(params)
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
  end

  def vote_manager_form
  end

  def vote_manager_existing_user
    user_id = params[:user_id]

    if user_id.nil?
      flash[:error] = "Ocurrió un error inesperado. Vuelve a intentarlo."
      redirect_to vote_manager_form_proposal_path(@proposal.id)
      return
    end

    if @proposal.voters.exists?(id: user_id)
      flash[:error] = "Ya hay un apoyo de este usuario."
      redirect_to vote_manager_form_proposal_path(@proposal.id)
      return
    end

    existing_user = User.find(user_id)

    @proposal.register_vote(existing_user, "yes")

    flash[:notice] = "Se apoyó la propuesta en nombre de: #{existing_user.full_name}"
    redirect_to proposal_path(@proposal.id)
  end

  def vote_manager_new_user
    clean_document_number = params[:user][:document_number].gsub(/[^a-z0-9]+/i, "").upcase

    if User.exists?(document_number: clean_document_number)
      flash[:error] = "Ya existe un usuario registrado con el RUT: #{clean_document_number}."
      redirect_to vote_manager_form_proposal_path(@proposal.id)
      return
    end

    if !params[:user][:email].empty? and User.exists?(email: params[:user][:email])
      flash[:error] = "Ya existe un usuario registrado con el email: #{params[:user][:email]}"
      redirect_to vote_manager_form_proposal_path(@proposal.id)
      return
    end

    permitted_params = params.require(:user).permit(
      :first_name,
      :last_name,
      :document_number,
      :email,
      :gender,
      :date_of_birth,
      :phone_number,
    ).merge(
      document_number: clean_document_number,
      email: params[:user][:email].empty? ? "manager_user_#{clean_document_number}@ugu.cl" : params[:user][:email]
    )

    new_user = User.new(permitted_params)

    new_user.save(validate: false)

    @proposal.register_vote(new_user, "yes")

    flash[:notice] = "Se apoyó la propuesta en nombre de: #{new_user.full_name}"
    redirect_to proposal_path(@proposal.id)
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
      params.require(:proposal).permit(allowed_params)
    end

    def allowed_params
      attributes = [:video_url, :responsible_name, :tag_list, :terms_of_service,
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


    def sort_by(params)
      proposals = @proposals
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
