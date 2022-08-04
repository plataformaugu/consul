class AddInDevelopmentFieldToProposals < ActiveRecord::Migration[5.2]
  def change
    add_column :proposals, :in_development, :boolean, default: false
  end
end
