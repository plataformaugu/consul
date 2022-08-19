class AccountController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account
  load_and_authorize_resource class: "User"

  def show
    @general_notifications = current_user.notifications.where.not(notifiable_type: 'CustomNotification')
    @custom_notifications = current_user.notifications.where(notifiable_type: 'CustomNotification')
    @comunas = get_comunas
  end

  def update
    if @account.update(account_params)
      redirect_to account_path, notice: t("flash.actions.save_changes.notice")
    else
      @account.errors.messages.delete(:organization)
      render :show
    end
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

    def set_account
      @account = current_user
    end

    def account_params
      attributes = if @account.organization?
                     [:phone_number, :email_on_comment, :email_on_comment_reply, :newsletter,
                      organization_attributes: [:name, :responsible_name]]
                   else
                     [:username, :public_activity, :public_interests, :email_on_comment,
                      :email_on_comment_reply, :email_on_direct_message, :email_digest, :newsletter,
                      :official_position_badge, :recommended_debates, :recommended_proposals]
                   end
      params.require(:account).permit(*attributes)
    end
end
