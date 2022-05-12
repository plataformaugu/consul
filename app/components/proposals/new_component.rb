class Proposals::NewComponent < ApplicationComponent
  include Header
  attr_reader :proposal

  def initialize(proposal, is_initiative)
    @proposal = proposal
    @is_initiative = is_initiative
  end

  def title
    t("proposals.new.start_new")
  end
end
