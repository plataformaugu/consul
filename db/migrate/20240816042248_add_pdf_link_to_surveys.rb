class AddPdfLinkToSurveys < ActiveRecord::Migration[6.0]
  def change
    add_column :surveys, :pdf_link, :string
  end
end
