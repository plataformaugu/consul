class ProposalsThemesController < ApplicationController
  before_action :set_proposals_theme, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  load_and_authorize_resource

  # GET /proposals_themes
  def index
    @proposals_themes = Kaminari.paginate_array(ProposalsTheme.all).page(params[:page])
  end

  # GET /proposals_themes/1
  def show
    @proposals = Kaminari.paginate_array(ProposalsTheme.find(params['id']).proposals.published).page(params[:page])
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

    if params['proposals_theme']['sector_ids']
      params['proposals_theme']['sector_ids'].each do |s|
        begin
          sector = Sector.find_by(name: s)
          @proposals_theme.sectors.append(sector)
        rescue
        end
      end
    end

    if @proposals_theme.save
      redirect_to @proposals_theme, notice: 'El tema fue creado.'
    else
      render :new
    end
  end

  # PATCH/PUT /proposals_themes/1
  def update
    if @proposals_theme.update(proposals_theme_params)
      redirect_to @proposals_theme, notice: 'El tema fue actualizado.'
    else
      render :edit
    end
  end

  # DELETE /proposals_themes/1
  def destroy
    ProposalsThemeSector.where(proposals_theme_id: @proposals_theme.id).destroy_all
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
      params.require(:proposals_theme).permit(:title, :description, :image, :start_date, :end_date, :is_public)
    end
end
