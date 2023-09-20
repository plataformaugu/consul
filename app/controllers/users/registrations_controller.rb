require "#{Rails.root}/lib/tarjeta_vecino_service"
require "#{Rails.root}/lib/las_condes_api"

class Users::RegistrationsController < Devise::RegistrationsController
  include TarjetaVecino
  include LasCondesAPI

  prepend_before_action :authenticate_scope!, only: [:edit, :update, :destroy, :finish_signup, :do_finish_signup]
  before_action :configure_permitted_parameters

  def new
    if params['codigo'].present? and params['estado'].present?
      response = validate_clave_unica_response

      if response.nil?
        flash[:alert] = "Ocurrió un error inesperado. Inténtalo más tarde."
        redirect_to new_user_registration_path
        return
      end

      if response[:found_user].present?
        if response[:found_user].deleted?
          flash[:alert] = 'Tu cuenta ha sido eliminada. Si quieres recuperarla contacta con nosotros.'
          redirect_to root_path
          return
        end

        if response[:found_user].confirmed?
          sign_in(:user, response[:found_user])

          if current_user.sign_in_count <= 1
            redirect_to tarjeta_vecino_path
          else
            if current_user.tarjeta_vecino_updated_at == nil || (Time.now.to_date - current_user.tarjeta_vecino_updated_at.to_date).to_i >= 7
              current_user.update_tarjeta_vecino()
              current_user.tarjeta_vecino_updated_at = Time.now
              current_user.save!
            end

            redirect_to root_path
          end

        else
          flash[:notice] = "Para ingresar debes confirmar tu cuenta en el correo que te enviamos."
          redirect_to root_path
        end
      else
        born_data = registro_civil_request(response[:data]['rut'], 'certificado-nacimiento')
        profession_data = registro_civil_request(response[:data]['rut'], 'informacion-profesion')
        home_data = registro_civil_request(response[:data]['rut'], 'informacion-domicilio')

        born_data = !born_data.nil? ? born_data.fetch('CertificadoNacimiento', {}) : {}
        profession_data = !profession_data.nil? ? profession_data.fetch('datosPersona', {}).fetch('datosProfesion', {}) : {}
        home_data = !home_data.nil? ? home_data.fetch('datoPersona', {}) : {}

        build_resource({
          username: "#{response[:data]['nombre'].downcase[0]}#{response[:data]['apellido_paterno'].downcase}#{response[:data]['rut'][..4]}",
          document_number: response[:data]['rut'],
          first_name: response[:data]['nombre'],
          last_name: response[:data]['apellido_paterno'],
          maiden_name: response[:data]['apellido_materno'],
          date_of_birth: !born_data.fetch('fechaNacimiento', nil).nil? ? Date.strptime(born_data['fechaNacimiento'], '%Y-%m-%d') : nil,
          civil_status: home_data.fetch('estadoCivil', nil),
          nationality: born_data.fetch('nacionalidadNacimiento', '').titleize,
          profession: (profession_data.is_a?(Hash) && !profession_data.fetch('tituloProfesional', nil).nil?) ? profession_data['tituloProfesional'].titleize : nil
        })

        @countries = get_countries
        @comunas = get_comunas
        render :new, locals: {temporal_resource: resource}
      end
    else
      render :clave_unica
      return
    end
  end

  def create
    build_resource(sign_up_params)
    resource.password = resource.username

    if resource.comuna == 'Las Condes' and !params['sector'].empty?
      resource.sector = Sector.where(name: "C#{params['sector']}").first
    end

    if !params['alt-street'].empty?
      resource.address = "#{params['alt-street']} #{params['alt-number']}"
      sector_data = get_sector_data("#{params['alt-street']} #{params['alt-number']}")

      if !sector_data.nil?
        resource.sector = Sector.where(name: "C#{sector_data['sector']}").first
        resource.lat = sector_data['lat'].gsub(',', '.').to_f
        resource.long = sector_data['long'].gsub(',', '.').to_f

        if resource.comuna == 'Las Condes'
          send_user_data_to_neighborhood_directory(
            resource,
            sector_data['id']
          )
          resource.id_direccion = sector_data['id'].to_i
        end
      end
    end

    tarjeta_vecino_data = get_tarjeta_vecino_data(resource.document_number)
    resource.neighbor_type_id = tarjeta_vecino_data[:neighbor_type].id

    if tarjeta_vecino_data[:has_tarjeta_vecino]
      resource.has_tarjeta_vecino = true

      if tarjeta_vecino_data[:is_tarjeta_vecino_active]
        resource.is_tarjeta_vecino_active = true
        resource.tarjeta_vecino_code = tarjeta_vecino_data[:tarjeta_vecino_code]
        resource.tarjeta_vecino_start_date = tarjeta_vecino_data[:tarjeta_vecino_start_date]
      end
    end

    if resource.valid?
      begin
        resource.save
      rescue Exception => e
        flash[:alert] = 'Ocurrió un error inesperado. Inténtalo más tarde o contacta con nosotros.'
        redirect_to root_path
        return
      end

      render :success
    end
  end

  def search
    if params['search'].present? and params['search'] != ''
      search = params['search']

      uri = URI("https://bus-datos.lascondes.cl/api/maestros/direcciones/direccion-like")
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      request = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
      request["Authorization"] = "Bearer A8Vq8HmOepf38i38i7D95RkF3kxhmeSOVlItK4rFim12tK4rFim12diVun3aHe9k9Ll0"
      request.body = JSON.dump({
        "q": search,
      })
      response = https.request(request)
      
      if response.kind_of? Net::HTTPSuccess
        render json: JSON.parse(response.body)['result']
      else
        render json: []
      end
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

  def delete_form
    build_resource({})
  end

  def delete
    current_user.erase(erase_params[:erase_reason])
    sign_out
    redirect_to root_path, notice: t("devise.registrations.destroyed")
  end

  def success
  end

  def finish_signup
    current_user.registering_with_oauth = false
    current_user.email = current_user.oauth_email if current_user.email.blank?
    current_user.validate
  end

  def do_finish_signup
    current_user.registering_with_oauth = false
    if current_user.update(sign_up_params)
      current_user.send_oauth_confirmation_instructions
      sign_in_and_redirect current_user, event: :authentication
    else
      render :finish_signup
    end
  end

  def check_username
    if User.find_by username: params[:username]
      render json: { available: false, message: t("devise_views.users.registrations.new.username_is_not_available") }
    else
      render json: { available: true, message: t("devise_views.users.registrations.new.username_is_available") }
    end
  end

  def check_email
    if User.find_by email: params[:email]
      render json: { available: false }
    else
      render json: { available: true }
    end
  end

  def get_countries
    JSON.parse(File.read(File.join(File.dirname(__FILE__), 'countries.json')))
  end

  def get_comunas
    comunas = JSON.parse(File.read(File.join(File.dirname(__FILE__), 'comunas.json')))
    comunas = comunas.pluck('name')
    comunas.delete('Las Condes')
    comunas.sort
    comunas.insert(0, 'Las Condes')

    return comunas
  end

  private

    def validate_clave_unica_response
      @secret = Rails.application.secrets.clave_unica_secret
      @code = params['codigo']
      result = clave_unica_request
      found_user = User.with_deleted.where(document_number: result['rut'].gsub(/[^0-9a-z ]/i, '')).first

      return {
        data: result,
        found_user: found_user
      }
    end

    def clave_unica_request
      begin
        uri = URI('https://claveunica.lascondes.cl/clave-unica/auth-info')
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true
        request = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
        request.body = {code: @code, secret: @secret}.to_json
        response = https.request(request)
        result = JSON.parse(response.body)
        return result
      rescue
        return nil
      end
    end

    def registro_civil_request(rut, type)
      begin
        uri = URI("https://bus-datos.lascondes.cl/api/srcei/#{type}/")
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true
        request = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
        request["Authorization"] = "Bearer A8Vq8HmOepf38i38i7D95RkF3kxhmeSOVlItK4rFim12tK4rFim12diVun3aHe9k9Ll0"
        request.body = JSON.dump({
          "rut": rut.split('-')[0],
          "dv": rut.split('-')[1]
        })
        response = https.request(request)
        result = JSON.parse(response.body)
        return result
      rescue
        return nil
      end
    end

    def sign_up_params
      params[:user].delete(:redeemable_code) if params[:user].present? && params[:user][:redeemable_code].blank?
      params[:user].delete(:address) if params[:user].present? && params[:user][:address].blank?
      params.require(:user).permit(
        :terms_of_service, 
        :redeemable_code, 
        :use_redeemable_code,
        :document_number,
        :email,
        :locale,
        :first_name,
        :last_name,
        :maiden_name,
        :address,
        :house_type,
        :username,
        :house_reference,
        :comuna,
        :date_of_birth,
        :civil_status,
        :gender,
        :phone_number,
        :nationality,
        :profession,
        :education,
        :lat,
        :long,
        :web_browser
      )
    end

    def user_sign_up_params
      sign_up_params.merge password: sign_up_params['username']
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:account_update, keys: [:email])
    end

    def erase_params
      params.require(:user).permit(:erase_reason)
    end

    def after_inactive_sign_up_path_for(resource_or_scope)
      users_sign_up_success_path
    end

    def clear_street(street)
      return street.downcase.gsub(/avenida|calle|av\.|psje\.|pasaje|pje.|pj.|ave./, '').squeeze(' ').strip
    end
end
