class Custom::ProposalTopicsPageComponent < Custom::SinglePageComponent
    delegate :current_user, to: :helpers
end
