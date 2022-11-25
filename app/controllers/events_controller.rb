class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_event, only: [:show, :join, :left]

  load_and_authorize_resource

  def index
    @events = Event.all
  end

  def show
  end

  def join
    if current_user.events.exists?(id: @event.id)
      redirect_to @event, alert: 'Ya estás participando en el evento.'
      return
    else
      current_user.events << @event
      redirect_to @event, notice: '¡Listo! Estás participando en el evento.'
      return
    end
  end

  def left
    unless current_user.events.exists?(id: @event.id)
      redirect_to @event, alert: 'No estás participando en este evento.'
      return
    else
      current_user.events.delete(@event)
      flash[:notice] = 'Dejaste de participar en el evento.'
      redirect_back(fallback_location: root_path)
      return
    end
  end

  private
    def set_event
      @event = Event.find(params[:id])
    end
end
