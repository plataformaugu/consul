class DebatesController < ApplicationController
  include FeatureFlags
  include CommentableActions
  include DocumentAttributes
  include FlagActions
  include Translatable

  before_action :authenticate_user!, except: [:index, :show, :participatory_public_accounts, :participatory_regulatory_plans]
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
    redirect_to root_path
  end

  def participatory_public_accounts
    @debates = Kaminari.paginate_array(
      @debates.published.where(debate_type: Debate::TYPE_PARTICIPATORY_PUBLIC_ACCOUNTS)
    ).page(params[:page])
  end

  def participatory_regulatory_plans
    @debates = Kaminari.paginate_array(
      @debates.published.where(debate_type: Debate::TYPE_PARTICIPATORY_REGULATORY_PLANS)
    ).page(params[:page])
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

  def new
    if [
      Debate::TYPE_PARTICIPATORY_PUBLIC_ACCOUNTS,
      Debate::TYPE_PARTICIPATORY_REGULATORY_PLANS
    ].include?(params['type'])
      @type = params['type']
      super
    else
      redirect_to root_path
    end
  end

  def create
    if [
      Debate::TYPE_PARTICIPATORY_PUBLIC_ACCOUNTS,
      Debate::TYPE_PARTICIPATORY_REGULATORY_PLANS
    ].include?(debate_params['debate_type'])
      @debate = Debate.new(debate_params.merge(author: current_user))

      if @debate.save
        @debate.publish
        Activity.log(current_user, :create, @debate)

        if current_user.administrator?
          Segmentation.generate(
            entity_name: @debate.class.name,
            entity_id: @debate.id,
            params: params
          )
        end

        redirect_to debate_path(@debate)
      else
        render :new
      end
    else
      render :new
    end
  end

  def edit
    @type = @debate.debate_type
    super
  end

  def update
    super
    Activity.log(current_user, :update, @debate)

    if current_user.administrator?
      Segmentation.generate(
        entity_name: @debate.class.name,
        entity_id: @debate.id,
        params: params
      )
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

    redirect_to @debate, notice: "#{@debate.verbose_name_with_pronoun.titleize} fue actualizado."
  end

  def publish
    @debate.publish
    redirect_to moderation_debates_path, notice: "¡#{@debate.verbose_name_with_pronoun.titleize} ha sido publicado!"
  end

  private

    def debate_params
      params.require(:debate).permit(allowed_params)
    end

    def allowed_params
      [
        :tag_list,
        :terms_of_service,
        :related_sdg_list,
        :image,
        :debate_type,
        translation_params(Debate),
        documents_attributes: document_attributes,
      ]
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
