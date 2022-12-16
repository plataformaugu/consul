class Custom::BigCardComponent < ApplicationComponent

  def initialize(title, description, image, supertitle = nil)
    @title = title
    @description = description
    @image = image
    @supertitle = supertitle
  end
end
