class AddPdfLinkToSurveys < ActiveRecord::Migration[5.2]
  def change
    add_column :surveys, :pdf_link, :string
  end
end
