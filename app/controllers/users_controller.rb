load "#{Rails.root}/lib/tarjeta_vecino_service.rb"

class UsersController < ApplicationController
  include TarjetaVecino
  load_and_authorize_resource
  helper_method :valid_interests_access?

  def show
    raise CanCan::AccessDenied if params[:filter] == "follows" && !valid_interests_access?(@user)
  end

  def update_tarjeta_vecino
    if current_user
      result = get_tarjeta_vecino_data(current_user.document_number.insert(-2, '-'))
      is_changed = false

      if current_user.has_tarjeta_vecino != result[:has_tarjeta_vecino]
        current_user.has_tarjeta_vecino = result[:has_tarjeta_vecino]
        is_changed = true
      end
      
      if current_user.is_tarjeta_vecino_active != result[:is_tarjeta_vecino_active]
        current_user.is_tarjeta_vecino_active = result[:is_tarjeta_vecino_active]
        is_changed = true
      end

      if current_user.neighbor_type.id != result[:neighbor_type].id
        current_user.neighbor_type_id = result[:neighbor_type].id
        is_changed = true
      end

      if is_changed
        current_user.save
        flash[:notice] = "¡Tus datos se actualizaron correctamente!"
      else
        flash[:alert] = "Tus datos de Tarjeta Vecino ya están actualizados."
      end

      redirect_to account_path
    end
  end

  def login
    if request.post?
      @key = Rails.application.secrets.clave_unica_key
      @state = SecureRandom.hex
      @clave_unica_url = "https://claveunica.lascondes.cl/clave-unica/#{@key}/#{@state}"

      redirect_to @clave_unica_url
    end
  end

  private

    def valid_interests_access?(user)
      user.public_interests || user == current_user
    end

end
