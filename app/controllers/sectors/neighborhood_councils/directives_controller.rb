module Sectors
  module NeighborhoodCouncils
    class DirectivesController < ApplicationController
      load_and_authorize_resource
      # GET /directives
      def index
        @neighborhood_council = NeighborhoodCouncil.find(params[:neighborhood_council_id])
        @directives = Kaminari.paginate_array(@neighborhood_council.directives.all).page(params[:page])
      end
    end
  end
end
