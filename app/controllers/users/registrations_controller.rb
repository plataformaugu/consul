class Users::RegistrationsController < Devise::RegistrationsController
  prepend_before_action :authenticate_scope!, only: [:edit, :update, :destroy, :finish_signup, :do_finish_signup]
  before_action :configure_permitted_parameters, :set_var

  invisible_captcha only: [:create], honeypot: :address, scope: :user

  def new
    super do |user|
      user.use_redeemable_code = true if params[:use_redeemable_code].present?
    end
  end

  def create
    new_username = '%s %s' % [sign_up_params[:username], sign_up_params[:surnames]]
    new_params = sign_up_params.clone
    new_params.merge!(username: new_username)
    build_resource(new_params)
    resource.username = new_username
    if resource.valid?
      resource.save
      render :success
    else
      render :new
    end
  end

  def delete_form
    build_resource({})
  end

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  def after_update_path_for(resource)
    return user_edit_success_path
  end

  def edit_success
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
      params.require(:user).permit(:username, :surnames, :town, :email, :password,
                                   :password_confirmation, :terms_of_service, :locale,
                                   :redeemable_code)
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:account_update, keys: [:username, :email, :town, :gender, :date_of_birth, :phone_number])
    end

    def erase_params
      params.require(:user).permit(:erase_reason)
    end

    def after_inactive_sign_up_path_for(resource_or_scope)
      users_sign_up_success_path
    end

    def set_var
      @towns = [
        'Algarrobo',
        'Cabildo',
        'Calera',
        'Calle Larga',
        'Cartagena',
        'Casablanca',
        'Catemu',
        'Concón',
        'El Quisco',
        'El Tabo',
        'Hijuelas',
        'Isla de Pascua',
        'Juan Fernández',
        'La Cruz',
        'La Ligua',
        'Limache',
        'Llaillay',
        'Los Andes',
        'Nogales',
        'Olmué',
        'Panquehue',
        'Papudo',
        'Petorca',
        'Puchuncaví',
        'Putaendo',
        'Quillota',
        'Quilpué',
        'Quintero',
        'Rinconada',
        'San Antonio',
        'San Esteban',
        'San Felipe',
        'Santa María',
        'Santo Domingo',
        'Valparaíso',
        'Villa Alemana',
        'Viña del Mar',
        'Zapallar',
        'Otra comuna',
      ]
    end
end
