class Admin::NeighborhoodCouncilsController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :set_neighborhood_council, only: [:show, :edit, :update, :destroy]
  before_action :set_layout, only: [:index]

  load_and_authorize_resource

  def index
    if !current_user.administrator?
      redirect_to root_path
    end

    @neighborhood_councils = NeighborhoodCouncil.all
  end

  def show
    @directives = @neighborhood_council.directives
    @events = @neighborhood_council.neighborhood_council_events
  end

  def new
    @neighborhood_council = NeighborhoodCouncil.new
  end

  def create
    @neighborhood_council = NeighborhoodCouncil.new(neighborhood_council_params)

    if @neighborhood_council.save
      redirect_to admin_neighborhood_councils_path, notice: 'La junta de vecinos fue creada correctamente.'
    else
      render :new
    end
  end

  def update
    if @neighborhood_council.update(neighborhood_council_params)

      redirect_to admin_neighborhood_councils_path, notice: 'La junta de vecinos fue actualizada correctamente.'
    else
      render :edit
    end
  end

  def destroy
    @neighborhood_council.destroy!
    redirect_to admin_neighborhood_councils_path, notice: 'La junta de vecinos fue eliminada.'
  end

  private

    def set_neighborhood_council
      @neighborhood_council = NeighborhoodCouncil.find(params[:id])
    end

    def neighborhood_council_params
      params.require(:neighborhood_council).permit(
        :name,
        :address,
        :phone_number,
        :email,
        :conformation_date,
        :sector_id,
        :whatsapp,
        :facebook,
        :twitter,
        :instagram,
        :url
      )
    end
end
