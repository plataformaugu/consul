class NeighborhoodCouncilEventsController < ApplicationController
  before_action :set_neighborhood_council_event, only: [:show, :edit, :update, :destroy]

  # GET /neighborhood_council_events
  def index
    @neighborhood_council_events = NeighborhoodCouncilEvent.all
  end

  # GET /neighborhood_council_events/1
  def show
  end

  # GET /neighborhood_council_events/new
  def new
    @neighborhood_council_event = NeighborhoodCouncilEvent.new
  end

  # GET /neighborhood_council_events/1/edit
  def edit
  end

  # POST /neighborhood_council_events
  def create
    @neighborhood_council_event = NeighborhoodCouncilEvent.new(neighborhood_council_event_params)

    if @neighborhood_council_event.save
      redirect_to @neighborhood_council_event, notice: 'Neighborhood council event was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /neighborhood_council_events/1
  def update
    if @neighborhood_council_event.update(neighborhood_council_event_params)
      redirect_to @neighborhood_council_event, notice: 'Neighborhood council event was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /neighborhood_council_events/1
  def destroy
    @neighborhood_council_event.destroy
    redirect_to neighborhood_council_events_url, notice: 'Neighborhood council event was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_neighborhood_council_event
      @neighborhood_council_event = NeighborhoodCouncilEvent.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def neighborhood_council_event_params
      params.require(:neighborhood_council_event).permit(:name, :place, :email, :phone_number, :neighborhood_council_id, :event_id)
    end
end
