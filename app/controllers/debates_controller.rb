class DebatesController < ApplicationController
  include FeatureFlags
  include CommentableActions
  include FlagActions
  include Translatable

  before_action :authenticate_user!, except: [:index, :show, :map]
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
    @featured_debates = @debates.featured
  end

  def index
    @debates = Kaminari.paginate_array(Debate.all.published.order('featured_at DESC NULLS LAST, created_at DESC')).page(params[:page])
  end

  def show
    super
    if @debate.published_at == nil
      if current_user and (current_user.administrator? or current_user.moderator?)
        redirect_to debate_path(@debate), status: :moved_permanently if request.path != debate_path(@debate)
      else
        redirect_to root_path
      end
    else
      redirect_to debate_path(@debate), status: :moved_permanently if request.path != debate_path(@debate)
    end
  end

  def create
    @debate = Debate.new(debate_params)
    @debate.author = current_user

    if current_user.administrator? or current_user.moderator?
      @debate.published_at = Time.now

      if params['debate']['sector_ids']
        params['debate']['sector_ids'].each do |s|
          begin
            sector = Sector.find_by(name: s)
            @debate.sectors.append(sector)
          rescue
          end
        end
      end

      params['debate']['neighbor_types'].each do |id|
        neighbor_type = NeighborType.find(id)
        @debate.neighbor_types.append(neighbor_type)
      end
    else
      Sector.all.each do |s|
        @debate.sectors.append(s)
      end
    end

    if @debate.save
      if current_user.administrator?
        redirect_to @debate
      else
        redirect_to share_debate_path(@debate.id)
      end
    else
      render :new
    end
  end

  def update
    if current_user and current_user.administrator?
      @debate = Debate.find(params[:id])

      if @debate.update(debate_params)
        if params['debate']['neighbor_types'].present?
          @debate.neighbor_types = []

          params['debate']['neighbor_types'].each do |id|
            neighbor_type = NeighborType.find(id)
            @debate.neighbor_types.append(neighbor_type)
          end
        end

        if params['debate']['sector_ids'].present?
          @debate.sector_ids = []
  
          params['debate']['sector_ids'].each do |sector_id|
            sector = Sector.find_by(name: sector_id)
            @debate.sectors.append(sector)
          end
        else
          @debate.sectors.delete_all()
        end

        redirect_to @debate, notice: 'El debate fue actualizado.'
      else
        render :edit
      end
    else
      redirect_to root_path
    end
  end

  def vote
    @debate.register_vote(current_user, params[:value])
    set_debate_votes(@debate)
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

  def destroy
    @debate = Debate.find_by(id: params['id'])
    @debate.hide

    redirect_to debates_path, notice: 'El debate ha sido eliminado.'
  end

  private

    def debate_params
      attributes = [:title, :description, :question, :image, :main_theme_id]
      params.require(:debate).permit(attributes)
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
