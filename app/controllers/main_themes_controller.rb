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
    @main_theme = MainTheme.new
  end

  # GET /main_themes/1/edit
  def edit
  end

  # POST /main_themes
  def create
    @main_theme = MainTheme.new(main_theme_params)

    if @main_theme.save
      redirect_to @main_theme, notice: 'Main theme was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /main_themes/1
  def update
    if @main_theme.update(main_theme_params)
      redirect_to @main_theme, notice: 'Main theme was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /main_themes/1
  def destroy
    @main_theme.destroy
    redirect_to main_themes_url, notice: 'Main theme was successfully destroyed.'
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
