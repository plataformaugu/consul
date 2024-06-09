class Shared::DropdownMenuComponent < ApplicationComponent
  def initialize(title, items)
    @title = title
    @items = items
  end
end
