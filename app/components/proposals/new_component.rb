class Proposals::NewComponent < ApplicationComponent
  include Header
  attr_reader :proposal

  def initialize(proposal, proposal_topic, lat = nil, lng = nil)
    @proposal = proposal
    @proposal_topic = proposal_topic
    @lat = lat
    @lng = lng
  end

  def title
    t("proposals.new.start_new")
  end
end
