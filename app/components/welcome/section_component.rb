class Welcome::SectionComponent < ApplicationComponent
  def initialize(title, path = nil, path_label = 'Ver todas')
    @title = title
    @path = path
    @path_label = path_label
  end
end
