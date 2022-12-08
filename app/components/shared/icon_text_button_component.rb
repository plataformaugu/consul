class Shared::IconTextButtonComponent < ApplicationComponent
  def initialize(url, icon_class, text, use_new_tab = false)
    @url = url
    @icon_class = icon_class
    @text = text
    @use_new_tab = use_new_tab
  end
end
