class AddMainThemeToEvents2 < ActiveRecord::Migration[5.2]
  def change
    add_reference :events, :main_theme, index: true
  end
end
