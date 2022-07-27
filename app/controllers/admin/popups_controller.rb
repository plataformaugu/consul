class Admin::PopupsController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_popup, only: [:show, :edit, :update, :destroy]
  before_action :set_layout, only: [:index]

  # GET /popups
  def index
    @popups = Popup.all
    @has_popup = Popup.any?
    @form_popup = Popup.any? ? Popup.first : Popup.new
  end

  # POST /popups
  def create
    @popup = Popup.new(popup_params)

    if @popup.save
      redirect_to admin_popups_path, notice: 'El popup fue creado correctamente.'
    else
      render admin_popups_path
    end
  end

  # PATCH/PUT /popups/1
  def update
    if @popup.update(popup_params)
      redirect_to admin_popups_path, notice: 'El popup fue actualizado correctamente.'
    else
      render admin_popups_path
    end
  end

  # DELETE /popups/1
  def destroy
    @popup.destroy
    redirect_to popups_url, notice: 'El popup fue eliminado.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_popup
      @popup = Popup.find(params[:id])
    end

    def popup_params
      params.require(:popup).permit(:image, :url, :is_active)
    end
end
