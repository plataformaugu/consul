class Admin::EventsController < Admin::BaseController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  NOTICE_TEXT = "El evento fue %{action} correctamente."

  def index
    @events = Event.all
  end

  def new
    @event = Event.new
  end

  def edit
  end

  def create
    @event = Event.new(event_params)

    if @event.save
      redirect_to admin_events_path, notice: NOTICE_TEXT % {action: 'creado'}
    else
      render :event
    end
  end

  def update
    if @event.update(event_params)
      redirect_to @event, notice: NOTICE_TEXT % {action: 'actualizado'}
    else
      render :edit
    end
  end

  def destroy
    @event.destroy
    redirect_to admin_events_path, notice: NOTICE_TEXT % {action: 'eliminado'}
  end

  private
    def set_event
      @event = Event.find(params[:id])
    end

    def event_params
      params.require(:event).permit(:title, :description, :start_time, :end_time, :image)
    end
end
