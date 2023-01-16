module Sectors
  module NeighborhoodCouncils
    class EventsController < ApplicationController
      before_action :set_neighborhood_council_event, only: [:show, :join_to_event, :left_event]
      load_and_authorize_resource
      # GET /directives
      def index
        @neighborhood_council = NeighborhoodCouncil.find(params[:neighborhood_council_id])
        @events = @neighborhood_council.neighborhood_council_events.all
      end

      def show
      end

      def join_to_event
        unless NeighborhoodCouncilEvent.exists?(id: params['id'])
          redirect_to root_path, alert: 'El evento no existe.'
          return
        end
    
        event = NeighborhoodCouncilEvent.find(params['id'])

        if current_user.neighborhood_council_events.exists?(id: params['id'])
          redirect_to sector_neighborhood_council_event_path(event.neighborhood_council.sector, event.neighborhood_council, event), alert: 'Ya estás participando en el evento.'
          return
        else
          if current_user
            current_user.neighborhood_council_events << event
            redirect_to sector_neighborhood_council_event_path(event.neighborhood_council.sector, event.neighborhood_council, event), notice: '¡Listo! Estás participando en el evento.'
            return
          end
        end
      end
    
      def left_event
        unless NeighborhoodCouncilEvent.exists?(id: params['id'])
          redirect_to root_path, alert: 'El evento no existe.'
          return
        end
    
        event = NeighborhoodCouncilEvent.find(params['id'])
    
        unless current_user.neighborhood_council_events.exists?(id: params['id'])
          redirect_to sector_neighborhood_council_event_path(event.neighborhood_council.sector, event.neighborhood_council, event), alert: 'No estás participando en este evento.'
          return
        else
          if current_user
            current_user.neighborhood_council_events.delete(event)
            if params['from'] == 'index'
              redirect_to sector_neighborhood_council_event_path(event.neighborhood_council.sector, event.neighborhood_council, event), notice: 'Dejaste de participar en el evento.'
            else
              redirect_to sector_neighborhood_council_event_path(event.neighborhood_council.sector, event.neighborhood_council, event), notice: 'Dejaste de participar en el evento.'
              return
            end
          end
        end
      end

      private

      def set_neighborhood_council_event
        @event = NeighborhoodCouncilEvent.find(params[:id])
      end
    end
  end
end
