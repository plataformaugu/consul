load "#{Rails.root}/lib/tarjeta_vecino_service.rb"
load "#{Rails.root}/lib/las_condes_api.rb"

class UsersController < ApplicationController
  include TarjetaVecino
  include LasCondesAPI

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

      if current_user.tarjeta_vecino_code != result[:tarjeta_vecino_code]
        current_user.tarjeta_vecino_code = result[:tarjeta_vecino_code]
        is_changed = true
      end

      if current_user.tarjeta_vecino_start_date != result[:tarjeta_vecino_start_date]
        current_user.tarjeta_vecino_start_date = result[:tarjeta_vecino_start_date]
        is_changed = true
      end

      if is_changed
        current_user.save
        flash[:notice] = "¡Tus datos se actualizaron correctamente!"
      else
        flash[:alert] = "Tus datos de Tarjeta Vecino ya están actualizados."
      end

      redirect_to account_path(anchor: 'tarjeta-vecino')
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
  
  def update
    is_updated = !User.where(user_params).exists?

    if is_updated or !params['alt-street'].empty?
      current_user.update(user_params)
      redirect_to account_path(anchor: 'mis-datos'), notice: '¡Tus datos fueron actualizados!'

      if user_params['comuna'] != 'Las Condes'
        current_user.sector = nil
        current_user.lat = nil
        current_user.long = nil
        current_user.save
      end

      if user_params['comuna'] == 'Las Condes'
        if !params['alt-street'].empty?
          current_user.address = "#{params['alt-street']} #{params['alt-number']}"
          sector_data = get_sector_data("#{params['alt-street']} #{params['alt-number']}")

          if !sector_data.nil?
            current_user.sector = Sector.where(name: "C#{sector_data['sector']}").first
            current_user.lat = sector_data['lat'].gsub(',', '.').to_f
            current_user.long = sector_data['long'].gsub(',', '.').to_f

            send_user_data_to_neighborhood_directory(
              current_user,
              sector_data['id']
            )
            current_user.id_direccion = sector_data['id'].to_i
          end
        else
          sector_data = get_sector_data(user_params['address'])

          if !sector_data.nil?
            send_user_data_to_neighborhood_directory(
              current_user,
              sector_data['id']
            )
            current_user.id_direccion = sector_data['id'].to_i
          end
        end

        current_user.save
      end
    else
      redirect_to account_path(anchor: 'mis-datos'), alert: 'Debes modificar tus datos para que se actualicen.'
    end
  end

  def get_sector_data(address)
    uri = URI("https://bus-datos.lascondes.cl/api/maestros/direcciones/direccion-like")
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    request = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
    request["Authorization"] = "Bearer A8Vq8HmOepf38i38i7D95RkF3kxhmeSOVlItK4rFim12tK4rFim12diVun3aHe9k9Ll0"
    request.body = JSON.dump({
      "q": address,
    })
    response = https.request(request)

    begin
      if response.kind_of? Net::HTTPSuccess
        result = JSON.parse(response.body)['result']

        if result.empty?
          return nil
        else
          sector_data = result[0]
          return {
            "sector" => sector_data['cod_unidadvecinal'],
            "lat" => sector_data['str_latitud'],
            "long" => sector_data['str_longitud'],
            "id" => sector_data['id']
          }
        end
      else
        return nil
      end
    rescue
      return nil
    rescue Exception
      return nil
    end
  end

  private

    def valid_interests_access?(user)
      user.public_interests || user == current_user
    end

    def user_params
      params.require(:user).permit(
        :document_number,
        :email,
        :gender,
        :phone_number,
        :comuna,
        :address,
        :house_type,
        :house_reference,
        :education,
      )
    end

end
