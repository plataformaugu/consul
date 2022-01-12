class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show, :map, :summary]

  skip_authorization_check
  load_and_authorize_resource

  # GET /events
  def index
    @events = Event.all
  end

  # GET /events/1
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  def create
    @event = Event.new(event_params)

    if event_params['start_time'].to_datetime >= event_params['end_time'].to_datetime
      @event.errors[:start_time] << 'El campo "Desde" no puede ser menor o igual a "Hasta".'
      render :new
    else
      if @event.save
        redirect_to @event, notice: 'El evento fue creado exitosamente.'
      else
        render :new
      end
    end
  end

  # PATCH/PUT /events/1
  def update
    if @event.update(event_params)
      redirect_to @event, notice: 'Se actualizó el evento.'
    else
      render :edit
    end
  end

  # DELETE /events/1
  def destroy
    @event.destroy
    redirect_to events_url, notice: 'Se eliminó el evento.'
  end

  def join_to_event
    unless Event.exists?(id: params['event_id'])
      redirect_to events_path, alert: 'El evento no existe.'
      return
    end

    event = Event.find(params['event_id'])

    if current_user.events.exists?(id: params['event_id'])
      redirect_to event_path(event.id), alert: 'Ya estás participando en el evento.'
      return
    else
      if current_user
        current_user.events << event
        redirect_to event_path(event.id), notice: '¡Listo! Estás participando en el evento.'
        return
      end
    end
  end

  def left_event
    unless Event.exists?(id: params['event_id'])
      redirect_to events_path, alert: 'El evento no existe.'
      return
    end

    event = Event.find(params['event_id'])

    unless current_user.events.exists?(id: params['event_id'])
      redirect_to event_path(event.id), alert: 'No estás participando en este evento.'
      return
    else
      if current_user
        current_user.events.delete(event)
        if params['from'] == 'index'
          redirect_to event_path(event), notice: 'Dejaste de participar en el evento.'
        else
          redirect_to events_path(anchor: 'my-events'), notice: 'Dejaste de participar en el evento.'
          return
        end
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def event_params
      params.require(:event).permit(:title, :description, :start_time, :end_time)
    end
end
