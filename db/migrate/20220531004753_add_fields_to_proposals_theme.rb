class AddFieldsToProposalsTheme < ActiveRecord::Migration[5.2]
  def change
    add_column :proposals_themes, :pdf_link, :string
  end
end
