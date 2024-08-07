class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_event, only: [:show, :join, :left, :pending, :participate_manager_form, :participate_manager_existing_user, :participate_manager_new_user]

  load_and_authorize_resource

  def index
    @events = Event.published
  end

  def show
  end

  def pending; end

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

  def participate_manager_form
  end

  def participate_manager_existing_user
    user_id = params[:user_id]

    if user_id.nil?
      flash[:error] = "Ocurrió un error inesperado. Vuelve a intentarlo."
      redirect_to participate_manager_form_event_path(@event.id)
      return
    end

    if @event.users.exists?(id: user_id)
      flash[:error] = "Este usuario ya está participando."
      redirect_to participate_manager_form_event_path(@event.id)
      return
    end

    existing_user = User.find(user_id)

    existing_user.events << @event

    flash[:notice] = "Se participó en el evento en nombre de: #{existing_user.full_name}"
    redirect_to event_path(@event.id)
  end

  def participate_manager_new_user
    clean_document_number = params[:user][:document_number].gsub(/[^a-z0-9]+/i, "").upcase

    if User.exists?(document_number: clean_document_number)
      flash[:error] = "Ya existe un usuario registrado con el RUT: #{clean_document_number}."
      redirect_to participate_manager_form_event_path(@event.id)
      return
    end

    if !params[:user][:email].empty? and User.exists?(email: params[:user][:email])
      flash[:error] = "Ya existe un usuario registrado con el email: #{params[:user][:email]}"
      redirect_to participate_manager_form_event_path(@event.id)
      return
    end

    permitted_params = params.require(:user).permit(
      :first_name,
      :last_name,
      :document_number,
      :email,
      :gender,
      :date_of_birth,
      :phone_number,
      :organization_name,
    ).merge(
      document_number: clean_document_number,
      email: params[:user][:email].empty? ? "manager_user_#{clean_document_number}@ugu.cl" : params[:user][:email],
      organization_name: current_user.organization_name
    )

    new_user = User.new(permitted_params)

    new_user.save(validate: false)

    new_user.events << @event

    flash[:notice] = "Se participó en el evento en nombre de: #{new_user.full_name}"
    redirect_to event_path(@event.id)
  end

  private
    def set_event
      @event = Event.find(params[:id])
    end
end
