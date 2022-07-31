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
      end

      redirect_to moderation_proposals_path, notice: 'Las propuestas fueron rechazadas.'
    end
  end

  private
    def resource_model
      Proposal
    end

end
