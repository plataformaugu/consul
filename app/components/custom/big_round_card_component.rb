class Custom::BigRoundCardComponent < ApplicationComponent
  def initialize(
    title,
    image,
    description,
    new_record_path = nil,
    readable_model_name = nil,
    extra_message = nil
  )
    @title = title
    @image = image
    @description = description
    @new_record_path = new_record_path
    @readable_model_name = readable_model_name
    @extra_message = extra_message
  end
end
