class AddFieldsToEncuestum < ActiveRecord::Migration[5.2]
  def change
    add_column :encuesta, :limit_date, :datetime
    add_reference :encuesta, :main_theme, index: true
  end
end
