class SectorsController < ApplicationController
  load_and_authorize_resource
  before_action :set_sector, only: [:show]

  def show
    @neighborhood_councils = Kaminari.paginate_array(@sector.neighborhood_councils).page(params[:page])
  end

  private
    def set_sector
      @sector = Sector.find(params[:id])
    end
end
