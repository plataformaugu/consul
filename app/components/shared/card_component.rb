class Shared::CardComponent < ApplicationComponent
  def initialize(instance, title, image, description, alert, subtitle = nil)
    @instance = instance
    @title = title
    @image = image
    @description = description
    @alert = alert
    @subtitle = subtitle
  end
end
