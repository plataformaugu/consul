class MainThemesController < ApplicationController
  before_action :set_main_theme, only: [:show, :edit, :update, :destroy]

  skip_authorization_check
  load_and_authorize_resource

  # GET /main_themes
  def index
    if current_user and current_user.administrator?
      @main_themes = MainTheme.all
    else
      redirect_to root_path
    end
  end

  # GET /main_themes/1
  def show
  end

  # GET /main_themes/new
  def new
    if current_user and current_user.administrator?
      @main_theme = MainTheme.new
    else
      redirect_to root_path
    end
  end

  # GET /main_themes/1/edit
  def edit
  end

  # POST /main_themes
  def create
    if current_user and current_user.administrator?
      @main_theme = MainTheme.new(main_theme_params)
  
      if @main_theme.save
        redirect_to @main_theme, notice: 'Main theme was successfully created.'
      else
        render :new
      end
    else
      redirect_to root_path
    end
  end

  # PATCH/PUT /main_themes/1
  def update
    if current_user and current_user.administrator?
      if @main_theme.update(main_theme_params)
        redirect_to @main_theme, notice: 'Main theme was successfully updated.'
      else
        render :edit
      end
    else
      redirect_to root_path
    end
  end

  # DELETE /main_themes/1
  def destroy
    if current_user and current_user.administrator?
      @main_theme.destroy
      redirect_to main_themes_url, notice: 'Main theme was successfully destroyed.'
    else
      redirect_to root_path
    end
  end

  def functional_organizations_index
    # Muestra el diseño con pasto junto a los ejes temáticos que poseen al menos 1 organización social
    @main_themes = {}

    MainTheme.all.each do |mt|
      @main_themes[mt.name] = mt.attributes.merge!({ 'count' => mt.functional_organizations.count })
    end
  end

  def functional_organizations
    # Muestra las organizaciones funcionales del eje tematico
    if !@main_theme.functional_organizations.any?
      redirect_to root_path
    else
      @functional_organizations = Kaminari.paginate_array(@main_theme.functional_organizations.order(created_at: :desc)).page(params[:page])
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_main_theme
      @main_theme = MainTheme.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def main_theme_params
      params.require(:main_theme).permit(:name, :description, :primary_color, :secondary_color, :icon, :image, :extra_image)
    end
end
