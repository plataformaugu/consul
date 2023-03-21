class ProposalsThemesController < ApplicationController
  before_action :set_proposals_theme, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  load_and_authorize_resource

  # GET /proposals_themes
  def index
    @proposals_themes = Kaminari.paginate_array(ProposalsTheme.where("start_date <= ?", Time.now)).page(params[:page])
  end

  # GET /proposals_themes/1
  def show
    @orders = [
      ['Más votadas', 'most_voted'],
      ['Menos votadas', 'least_voted'],
      ['Más recientes', 'newest'],
      ['Más antiguas', 'oldest']
    ]
    @selected_order = params[:order]
    @proposals = sort_by(params)
    
    @can_participate = true
    @reason = nil

    if current_user && !current_user.administrator? && @proposals_theme.segmentation.present?
      @can_participate, @reason = @proposals_theme.segmentation.validate(current_user)
    end
  end

  # GET /proposals_themes/new
  def new
    if current_user and !current_user.administrator?
      redirect_to root_path
    end

    @proposals_theme = ProposalsTheme.new
  end

  # GET /proposals_themes/1/edit
  def edit
  end

  # POST /proposals_themes
  def create
    @proposals_theme = ProposalsTheme.new(proposals_theme_params)

    if @proposals_theme.save
      Segmentation.generate(entity_name: @proposals_theme.class.name, entity_id: @proposals_theme.id, params: params)
      redirect_to @proposals_theme, notice: 'El tema fue creado.'
    else
      render :new
    end
  end

  # PATCH/PUT /proposals_themes/1
  def update
    if @proposals_theme.update(proposals_theme_params)
      Segmentation.generate(entity_name: @proposals_theme.class.name, entity_id: @proposals_theme.id, params: params)
      redirect_to @proposals_theme, notice: 'El tema fue actualizado.'
    else
      render :edit
    end
  end

  # DELETE /proposals_themes/1
  def destroy
    ProposalsThemeSector.where(proposals_theme_id: @proposals_theme.id).destroy_all
    ProposalsThemeNeighborType.where(proposals_theme_id: @proposals_theme.id).destroy_all
    @proposals_theme.proposals.destroy_all
    @proposals_theme.destroy
    redirect_to proposals_themes_url, notice: 'El tema fue eliminado.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_proposals_theme
      @proposals_theme = ProposalsTheme.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def proposals_theme_params
      params.require(:proposals_theme).permit(:title, :description, :image, :start_date, :end_date, :is_public, :pdf_link)
    end

    def sort_by(params)
      proposals = ProposalsTheme.find(params['id']).proposals.published
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
