class AddPdfLinkToPoll < ActiveRecord::Migration[5.2]
  def change
    add_column :polls, :pdf_link, :string
  end
end
