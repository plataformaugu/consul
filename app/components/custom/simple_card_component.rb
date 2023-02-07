class Custom::SimpleCardComponent < ApplicationComponent
  delegate :current_user, to: :helpers

  def initialize(title, text = nil, image = nil)
    @title = title
    @text = text
    @image = image
  end
end
