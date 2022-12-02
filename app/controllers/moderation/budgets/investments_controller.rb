class Moderation::Budgets::InvestmentsController < Moderation::BaseController
  include FeatureFlags
  include ModerateActions

  has_filters %w[pending_flag_review all with_ignored_flag], only: :index
  has_orders  %w[flags created_at], only: :index

  feature_flag :budgets

  before_action :load_resources, only: [:index, :moderate]

  load_and_authorize_resource class: "Budget::Investment"

  def publish
    @investment = Budget::Investment.find_by(id: params['id'])
    @investment.confirmed_at = Time.now
    @investment.save

    redirect_to moderation_budget_investments_path, notice: 'El proyecto fue publicado.'
  end

  def reject
    if params['selected_ids'].any?
      params['selected_ids'].each do |id|
        investment = Budget::Investment.find_by(id: id)
        investment.custom_hide(current_user)
        # TODO: Enviar email y notificación al rechazar proyecto
        # Mailer.reject_debate(debate).deliver_later
        # custom_notification = CustomNotification.create(model: 'Debate', model_id: debate.id, action: 'reject_debate')
        # Notification.create(user_id: debate.author.id, notifiable_type: 'CustomNotification', notifiable_id: custom_notification.id)
      end

      redirect_to moderation_budget_investments_path, notice: 'Los proyectos fueron rechazados.'
    end
  end

  private

    def resource_name
      "budget_investment"
    end

    def resource_model
      Budget::Investment
    end
end
