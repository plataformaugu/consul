class Moderation::ProposalsController < Moderation::BaseController
  include ModerateActions
  include FeatureFlags

  has_orders %w[created_at], only: :index

  load_and_authorize_resource

  def index
    @proposals = Proposal.where(published_at: nil)
  end

  def reject
    if params['selected_ids'].any?
      params['selected_ids'].each do |id|
        proposal = Proposal.find(id)
        proposal.hide
        Mailer.reject_proposal(proposal).deliver_later
        custom_notification = CustomNotification.create(model: 'Proposal', model_id: proposal.id, action: 'reject_proposal')
        Notification.create(user_id: proposal.author.id, notifiable_type: 'CustomNotification', notifiable_id: custom_notification.id)
      end

      redirect_to moderation_proposals_path, notice: 'Las propuestas fueron rechazadas.'
    end
  end

  private
    def resource_model
      Proposal
    end

end
