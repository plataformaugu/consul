class Proposals::NewComponent < ApplicationComponent
  include Header
  attr_reader :proposal

  def initialize(proposal, is_initiative, proposals_theme = nil)
    @proposal = proposal
    @is_initiative = is_initiative
    @proposals_theme = proposals_theme
  end

  def title
    t("proposals.new.start_new")
  end
end
