class Shared::HorizontalCardComponent < ApplicationComponent
  def initialize(instance, title, image, description, alert, extra_info = nil, footer_text = nil)
    @instance = instance
    @title = title
    @image = image
    @description = description
    @alert = alert
    @extra_info = extra_info
    @footer_text = footer_text
  end
end
