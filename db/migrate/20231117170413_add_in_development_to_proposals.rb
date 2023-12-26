class AddInDevelopmentToProposals < ActiveRecord::Migration[6.0]
  def change
    add_column :proposals, :in_development, :boolean, default: false
  end
end
