module Sectors
  class NeighborhoodCouncilsController < ApplicationController
    load_and_authorize_resource
    before_action :set_neighborhood_council, only: [:show, :news]

    # GET /neighborhood_councils/1
    def show
    end

    def news
      @news = @neighborhood_council.news
    end

    private
      def set_neighborhood_council
        @neighborhood_council = NeighborhoodCouncil.find(params[:id])
      end
  end
end
