class AddFieldsToEncuesta < ActiveRecord::Migration[5.2]
  def change
    add_column :encuesta, :pdf_link, :string
    add_column :encuesta, :results_code, :text
    add_column :encuesta, :start_date, :date
  end
end
