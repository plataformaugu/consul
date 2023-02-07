class Custom::DirectiveCardComponent < ApplicationComponent
  delegate :current_user, to: :helpers

  def initialize(directive)
    @directive = directive
  end
end
