class Custom::BigCircleSimpleComponent < ApplicationComponent

  def initialize(title, image, new_record_path = nil, readable_model_name = nil)
    @title = title
    @image = image
    @new_record_path = new_record_path
    @readable_model_name = readable_model_name
  end
end
