class Welcome::SectionComponent < ApplicationComponent
  def initialize(title, path = nil)
    @title = title
    @path = path
  end
end
