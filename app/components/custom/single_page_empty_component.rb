class Custom::SinglePageEmptyComponent < ApplicationComponent

  def initialize(title, subtitle, image, readable_model_name, vowel, new_record_path = nil)
    @title = title
    @subtitle = subtitle
    @image = image
    @readable_model_name = readable_model_name
    @vowel = vowel
    @new_record_path = new_record_path
  end
end
