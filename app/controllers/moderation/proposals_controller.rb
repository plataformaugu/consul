class Moderation::ProposalsController < Moderation::BaseController
  include ModerateActions
  include FeatureFlags

  has_orders %w[created_at], only: :index

  load_and_authorize_resource

  def index
    @proposals = Proposal.where(published_at: nil)
  end

  private
    def resource_model
      Proposal
    end

end
