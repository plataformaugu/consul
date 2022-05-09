require_relative '../../services/tarjeta_vecino_service'

class Users::RegistrationsController < Devise::RegistrationsController
  include TarjetaVecino
  prepend_before_action :authenticate_scope!, only: [:edit, :update, :destroy, :finish_signup, :do_finish_signup]
  before_action :configure_permitted_parameters

  def new
    if params['codigo'].present? and params['estado'].present?
      response = validate_clave_unica_response

      if response[:found_user].present?
        sign_in(:user, response[:found_user])
      else
        puts 'NONONON'
        super do |user|
          user.use_redeemable_code = true if params[:use_redeemable_code].present?
        end
      end
    else
      render :clave_unica
      return
    end
  end

  def create
    @countries = get_countries
    @comunas = get_comunas
    puts params
    raise

    if params[:type] == 'pre'
      result = get_tarjeta_vecino_data(params[:document_number])

      build_resource({})
      if result == nil
        resource.document_number = params['document_number']
      end
      render :new, locals: {result: result}
      return
    else
      valid_location = true

      begin
        if params['check_location'] == 'true' and sign_up_params[:comuna].downcase.include? 'condes'
          url = URI("https://arcgislc.lascondes.cl/api/buscador/direccion/?calle=#{clear_street(sign_up_params[:street])}&numero=#{sign_up_params[:house_number]}&format=json")
          response = Net::HTTP.get(url)
          data = JSON.parse(response)
          if data["mensaje"].downcase != 'ok'
            valid_location = false
          end
        end
      rescue
        valid_location = true
      rescue Exception
        valid_location = true
      end

      build_resource(sign_up_params)
      if resource.valid? and valid_location
        super
      else
        result = get_tarjeta_vecino_data(params['user']['document_number'])
        if result == nil
          result = {:rut_vecino => params['user']['document_number']}
        end

        unless valid_location
          resource.errors.add(:street, 'dirección no encontrada en la comuna')
        end

        render :new, locals: {result: result}
      end
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

  def get_countries
    JSON.parse(File.read(File.join(File.dirname(__FILE__), 'countries.json')))
  end

  def get_comunas
    JSON.parse(File.read(File.join(File.dirname(__FILE__), 'comunas.json')))
  end

  private

    def validate_clave_unica_response
      @secret = '23bdf471bf3fab3a563bce73a3d1568d'
      @code = params['codigo']
      result = clave_unica_request
      found_user = User.where(document_number: result['rut'].gsub(/[^0-9a-z ]/i, '')).first

      return {
        data: result,
        found_user: found_user
      }
    end

    def clave_unica_request
      uri = URI('https://claveunica.lascondes.cl/clave-unica/auth-info')
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      request = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
      request.body = {code: @code, secret: @secret}.to_json
      response = https.request(request)
      result = JSON.parse(response.body)

      return result
    end

    def sign_up_params
      params[:user].delete(:redeemable_code) if params[:user].present? && params[:user][:redeemable_code].blank?
      params[:user].delete(:address) if params[:user].present? && params[:user][:address].blank?
      params.require(:user).permit(
        :document_number,
        :email,
        :password,
        :password_confirmation, 
        :terms_of_service, 
        :locale,
        :redeemable_code, 
        :use_redeemable_code,
        :first_name,
        :last_name,
        :maiden_name,
        :street,
        :house_number,
        :username,
        :house_apartment,
        :house_block,
        :comuna,
        :neighbordhood_unit,
        :date_of_birth,
        :civil_status,
        :gender,
        :phone_number,
        :nationality,
        :profession,
        :occupation,
        :prevision,
        :children_amount,
        :pets_amount
      )
    end

    def user_sign_up_params
      sign_up_params.merge username: "#{sign_up_params['first_name'].gsub(' ', '')}#{sign_up_params['last_name'][0..1]}#{sign_up_params['maiden_name'][0..1]}#{sign_up_params['document_number'][0..4]}".downcase.parameterize.gsub(' ', '')
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
