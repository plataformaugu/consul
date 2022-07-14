class AddShowDemographicsToPolls < ActiveRecord::Migration[5.2]
  def change
    add_column :polls, :show_demographics, :boolean
  end
end
