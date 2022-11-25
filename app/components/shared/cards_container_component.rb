class Shared::CardsContainerComponent < ApplicationComponent
  def initialize(records, title_field = 'title', description_field = 'description', image_field = 'image')
    @records = records
    @title_field = title_field
    @description_field = description_field
    @image_field = image_field
  end
end
