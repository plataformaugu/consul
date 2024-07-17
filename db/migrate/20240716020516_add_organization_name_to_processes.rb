class AddOrganizationNameToProcesses < ActiveRecord::Migration[6.0]
  def change
    add_column :proposal_topics, :organizations, :string, array: true, default: []
    add_column :polls, :organizations, :string, array: true, default: []
    add_column :surveys, :organizations, :string, array: true, default: []
  end
end
