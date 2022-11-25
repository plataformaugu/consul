class Shared::CardComponent < ApplicationComponent
  def initialize(instance, title, image, description, alert)
    @instance = instance
    @title = title
    @image = image
    @description = description
    @alert = alert
  end
end
