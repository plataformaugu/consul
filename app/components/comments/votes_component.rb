class Comments::VotesComponent < ApplicationComponent
  attr_reader :comment
  delegate :can?, to: :helpers

  def initialize(comment, is_disabled = false)
    @comment = comment
    @is_disabled = is_disabled
  end
end
