class Proposals::NewComponent < ApplicationComponent
  include Header
  attr_reader :proposal

  def initialize(proposal, proposal_topic, is_municipal = false)
    @proposal = proposal
    @proposal_topic = proposal_topic
    @is_municipal = is_municipal
  end

  def title
    t("proposals.new.start_new")
  end
end
