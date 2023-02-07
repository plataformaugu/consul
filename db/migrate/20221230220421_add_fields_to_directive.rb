class AddFieldsToDirective < ActiveRecord::Migration[5.2]
  def change
    add_column :directives, :image, :string
    add_column :directives, :start_date, :date
    add_column :directives, :end_date, :date
  end
end
