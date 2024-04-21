class AddTypeToDebates < ActiveRecord::Migration[6.0]
  def change
    add_column :debates, :debate_type, :string
  end
end
