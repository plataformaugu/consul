class DebatesController < ApplicationController
  include FeatureFlags
  include CommentableActions
  include FlagActions
  include Translatable

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

    if @debates.any?
      redirect_to @debates.first
    end
  end

  def index
    super
    @debates = @debates.published
  end

  def show
    super
    @debates = Debate.published
    redirect_to debate_path(@debate), status: :moved_permanently if request.path != debate_path(@debate)
  end

  def vote
    @debate.register_vote(current_user, params[:value])
  end

  def create
    @debate = Debate.new(debate_params.merge(author: current_user))

    if @debate.save
      redirect_to pending_debate_path(@debate)
    else
      render :new
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

    redirect_to @debate, notice: 'El debate ha sido actualizado.'
  end

  def publish
    @debate.publish
    redirect_to moderation_debates_path, notice: '¡El debate ha sido publicado!'
  end

  private

    def debate_params
      params.require(:debate).permit(allowed_params)
    end

    def allowed_params
      [:tag_list, :terms_of_service, :related_sdg_list, :image, translation_params(Debate)]
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
