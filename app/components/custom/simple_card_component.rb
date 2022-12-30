class Custom::SimpleCardComponent < ApplicationComponent
  delegate :current_user, to: :helpers

  def initialize(title, text)
    @title = title
    @text = text
  end
end
