class Custom::SinglePageComponent < ApplicationComponent
  delegate :current_user, to: :helpers

  def initialize(title, subtitle, image, readable_model_name, vowel, default_image, records, current_record = nil, new_record_path = nil, title_field = 'title', image_field = 'image')
    @title = title
    @subtitle = subtitle
    @image = image
    @readable_model_name = readable_model_name
    @vowel = vowel
    @default_image = default_image
    @records = records
    @current_record = current_record
    @new_record_path = new_record_path
    @title_field = title_field
    @image_field = image_field
  end
end
