class Moderation::ProposalsController < Moderation::BaseCustomController

  private

    def readable_model
      'propuesta'
    end

    def resource_model
      Proposal
    end

    def get_records
      Proposal.where(published_at: nil)
    end
end
