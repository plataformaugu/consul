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
    resource = build_resource(sign_up_params)
    resource.registering_from_web = true

    clean_document_number = sign_up_params[:document_number].gsub(/[^a-z0-9]+/i, "").upcase

    if (
      User.exists?(document_number: clean_document_number) &&
      !User.find_by(document_number: clean_document_number).encrypted_password.blank?
    )
      resource.errors.add(:document_number, 'ya está en uso')
      render :new
      return
    end

    if resource.valid?
      clean_document_number = sign_up_params[:document_number].gsub(/[^a-z0-9]+/i, "").upcase

      if (
        User.exists?(document_number: clean_document_number) &&
        User.find_by(document_number: clean_document_number).encrypted_password.blank?
      )
        found_user = User.find_by(document_number: clean_document_number)
        found_user.first_name = sign_up_params[:first_name]
        found_user.last_name = sign_up_params[:last_name]
        found_user.email = sign_up_params[:email]
        found_user.gender = sign_up_params[:gender]
        found_user.date_of_birth = sign_up_params[:date_of_birth]
        found_user.password = sign_up_params[:password]
        found_user.save!

        redirect_to users_sign_up_success_path
        return
      else
        super
      end
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
        :organization_name
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
end
