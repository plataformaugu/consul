class Custom::BigCardComponent < ApplicationComponent

  def initialize(id, title, summary, description, image, supertitle = nil, path = nil, small_description = false, show_see_more = false)
    @id = id
    @title = title
    @summary = summary
    @description = description
    @image = image
    @supertitle = supertitle
    @path = path
    @small_description = small_description
    @show_see_more = show_see_more
  end
end
