class DebatesController < ApplicationController
  include FeatureFlags
  include CommentableActions
  include FlagActions
  include Translatable
  include DocumentAttributes

  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_view, only: :index
  before_action :debates_recommendations, only: :index, if: :current_user

  feature_flag :debates

  invisible_captcha only: [:create, :update], honeypot: :subtitle

  has_orders ->(c) { Debate.debates_orders(c.current_user) }, only: :index
  has_orders %w[most_voted newest oldest], only: :show

  load_and_authorize_resource
  helper_method :resource_model, :resource_name
  respond_to :html, :js

  def index_customization
    @debates = Debate.published
    @featured_debates = @debates.featured
  end

  def index
    super
    @debates_open = @debates.published.not_finished
    @debates_finished = @debates.published.finished
  end

  def show
    super
    @can_participate = true
    @reason = nil

    if current_user && !current_user.administrator? && @debate.segmentation.present?
      @can_participate, @reason = @debate.segmentation.validate(current_user)
    end

    redirect_to debate_path(@debate), status: :moved_permanently if request.path != debate_path(@debate)
  end

  def vote
    @debate.register_vote(current_user, params[:value])
  end

  def create
    @debate = Debate.new(debate_params.merge(author: current_user))

    if @debate.save
      @debate.published_at = Time.now
      @debate.save!

      Segmentation.generate(entity_name: @debate.class.name, entity_id: @debate.id, params: params)
      redirect_to @debate
    else
      render :new
    end
  end

  def update
    if @debate.update(debate_params)
      Segmentation.generate(entity_name: @debate.class.name, entity_id: @debate.id, params: params)
      redirect_to debate_path(@debate), notice: "El Plan Regulador fue actualizado"
    else
      render :edit
    end
  end

  def unmark_featured
    @debate.update!(featured_at: nil)
    redirect_to debates_path
  end

  def mark_featured
    @debate.update!(featured_at: Time.current)
    redirect_to debates_path
  end

  def disable_recommendations
    if current_user.update(recommended_debates: false)
      redirect_to debates_path, notice: t("debates.index.recommendations.actions.success")
    else
      redirect_to debates_path, error: t("debates.index.recommendations.actions.error")
    end
  end

  def toggle_finished
    @debate.is_finished = !@debate.is_finished
    @debate.save

    redirect_to @debate, notice: 'El Plan Regulador ha sido actualizado.'
  end

  def publish
    @debate.publish
    redirect_to moderation_debates_path, notice: '¡El Plan Regulador ha sido publicado!'
  end

  private

    def debate_params
      params.require(:debate).permit(allowed_params)
    end

    def allowed_params
      valid_attributes = [:tag_list, :terms_of_service, :related_sdg_list, :image, documents_attributes: document_attributes]
      [*valid_attributes, translation_params(Debate)] 
    end

    def resource_model
      Debate
    end

    def set_view
      @view = (params[:view] == "minimal") ? "minimal" : "default"
    end

    def debates_recommendations
      if Setting["feature.user.recommendations_on_debates"] && current_user.recommended_debates
        @recommended_debates = Debate.recommendations(current_user).sort_by_random.limit(3)
      end
    end
end
