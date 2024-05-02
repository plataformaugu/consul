class Users::RegistrationsController < Devise::RegistrationsController
  prepend_before_action :authenticate_scope!, only: [:edit, :update, :destroy, :finish_signup, :do_finish_signup]
  before_action :configure_permitted_parameters

  invisible_captcha only: [:create], honeypot: :address, scope: :user

  def new
    super do |user|
      user.use_redeemable_code = true if params[:use_redeemable_code].present?
    end
  end

  def create
    build_resource(sign_up_params)
    resource.registering_from_web = true

    is_address_valid = validate_user_address(sign_up_params)

    if !is_address_valid
      flash[:error] = 'La dirección debe ser válida.'
      render :new
      return
    end

    coordinates = GeocodingService.get_coordinates(
      sign_up_params['street_name'],
      sign_up_params['house_number']
    )

    if coordinates["latitude"].present? and coordinates["longitude"].present?
      resource.latitude = coordinates["latitude"]
      resource.longitude = coordinates["longitude"]

      sector = Sector.get_sector_by_coordinates(
        coordinates["latitude"],
        coordinates["longitude"]
      )
      resource.sector = sector
    end

    if resource.valid?
      begin
        resource.save
      rescue Exception => e
        flash[:alert] = 'Ocurrió un error inesperado. Inténtalo más tarde o contacta con nosotros.'
        logger.error("[REGISTRATIONS CONTROLLER] Failed user creation")
        logger.error e.message

        redirect_to root_path
        return
      end

      render :success
    else
      render :new
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

  private

    def sign_up_params
      params[:user].delete(:redeemable_code) if params[:user].present? && params[:user][:redeemable_code].blank?
      params.require(:user).permit(allowed_params)
    end

    def allowed_params
      [
        :first_name,
        :last_name,
        :email,
        :email_confirmation,
        :password,
        :password_confirmation,
        :terms_of_service,
        :locale,
        :date_of_birth,
        :gender,
        :redeemable_code,
        :commune,
        :document_number,
        :street_name,
        :house_number
      ]
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

    def validate_user_address(sign_up_params)
      is_valid = true

      result_address = LoBarnecheaApi.new.search_address(
        sign_up_params['street_name'],
        sign_up_params['house_number']
      )

      if result_address.empty?
        is_valid = false
      end

      first_address_result = result_address[0]

      if first_address_result[0] != sign_up_params['street_name'] or first_address_result[1] != sign_up_params['house_number']
        is_valid = false
      end

      return is_valid
    end
end
