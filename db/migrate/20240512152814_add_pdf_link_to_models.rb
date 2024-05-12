class AddPdfLinkToModels < ActiveRecord::Migration[6.0]
  def change
    add_column :debates, :pdf_link, :string
    add_column :polls, :pdf_link, :string
    add_column :proposal_topics, :pdf_link, :string
  end
end
