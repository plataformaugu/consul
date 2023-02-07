class Admin::NeighborhoodCouncilEventsController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :set_layout, only: [:index]

  load_and_authorize_resource

  def new
    @neighborhood_council = NeighborhoodCouncil.find(params[:neighborhood_council_id])
    @event = NeighborhoodCouncilEvent.new
  end

  def create
    @event = NeighborhoodCouncilEvent.new(neighborhood_council_event_params)

    if @event.save
      redirect_to admin_neighborhood_council_path(@event.neighborhood_council.id, anchor: 'events'), notice: 'El evento fue creado correctamente.'
    else
      render :new
    end
  end

  def edit
    @neighborhood_council = @event.neighborhood_council
  end

  def update
    if @event.update(neighborhood_council_event_params)

      redirect_to admin_neighborhood_council_path(@event.neighborhood_council.id, anchor: 'events'), notice: 'El evento fue actualizado correctamente.'
    else
      render :edit
    end
  end

  def destroy
    @event.destroy!
    redirect_to admin_neighborhood_council_path(@event.neighborhood_council.id, anchor: 'events'), notice: 'El evento fue eliminado.'
  end

  private

    def set_event
      @event = NeighborhoodCouncilEvent.find(params[:id])
    end

    def neighborhood_council_event_params
      params.require(:neighborhood_council_event).permit(
        :title,
        :start_time,
        :end_time,
        :place,
        :email,
        :phone_number,
        :neighborhood_council_id,
      )
    end
end
