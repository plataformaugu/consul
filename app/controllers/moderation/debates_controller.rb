class Moderation::DebatesController < Moderation::BaseController
  include ModerateActions
  include FeatureFlags

  has_filters %w[pending_flag_review all with_ignored_flag], only: :index
  has_orders %w[flags created_at], only: :index

  feature_flag :debates

  before_action :load_resources, only: [:index, :moderate]

  load_and_authorize_resource

  def publish
    @debate = Debate.find_by(id: params['id'])
    @debate.published_at = Time.now
    @debate.save
    
    redirect_to moderation_debates_path, notice: 'El debate fue publicado.'
  end

  def reject
    if params['selected_ids'].any?
      params['selected_ids'].each do |id|
        debate = Debate.find(id)
        debate.hide
        Mailer.reject_debate(debate).deliver_later
        custom_notification = CustomNotification.create(model: 'Debate', model_id: debate.id, action: 'reject_debate')
        Notification.create(user_id: debate.author.id, notifiable_type: 'CustomNotification', notifiable_id: custom_notification.id)
      end

      redirect_to moderation_debates_path, notice: 'Los debates fueron rechazados.'
    end
  end

  def toggle_is_finished
    @debate = Debate.find_by(id: params['id'])
    new_value = !@debate.is_finished
    @debate.is_finished = new_value
    @debate.save

    if new_value
      message = 'El debate ha sido marcado como "Finalizado"'
    else
      message = 'El debate ya no está "Finalizado"'
    end

    redirect_to @debate, notice: message
  end

  private

    def index
      @debates = Debate.unpublished
    end

    def resource_model
      Debate
    end
end
