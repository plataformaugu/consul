class Proposals::NewComponent < ApplicationComponent
  include Header
  attr_reader :proposal
  delegate :current_user, to: :helpers

  def initialize(proposal, proposal_topic)
    @proposal = proposal
    @proposal_topic = proposal_topic
  end

  def title
    t("proposals.new.start_new")
  end
end
