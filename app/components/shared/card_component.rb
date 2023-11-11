class Shared::CardComponent < ApplicationComponent
  def initialize(instance, title, image, description, alert, extra_info = nil)
    @instance = instance
    @title = title
    @image = image
    @description = description
    @alert = alert
    @extra_info = extra_info
  end
end
