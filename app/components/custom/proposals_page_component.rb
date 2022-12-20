class Custom::ProposalsPageComponent < Custom::SinglePageComponent
    include ProposalsHelper
    delegate :current_user, to: :helpers
end
