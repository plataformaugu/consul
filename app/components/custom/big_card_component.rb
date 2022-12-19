class Custom::BigCardComponent < ApplicationComponent

  def initialize(id, title, summary, description, image, supertitle = nil, path = nil, small_description = false)
    @id = id
    @title = title
    @summary = summary
    @description = description
    @image = image
    @supertitle = supertitle
    @path = path
    @small_description = small_description
  end
end
