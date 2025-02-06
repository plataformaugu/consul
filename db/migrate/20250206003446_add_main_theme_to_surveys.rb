class AddMainThemeToSurveys < ActiveRecord::Migration[5.2]
  def change
    add_reference :surveys, :main_theme, index: true
  end
end
