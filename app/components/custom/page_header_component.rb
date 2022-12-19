class Custom::PageHeaderComponent < ApplicationComponent

  def initialize(title, description, image)
    @title = title
    @description = description
    @image = image
  end
end
