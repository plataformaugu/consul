class AddCuVerifiedOnlyToProcesses < ActiveRecord::Migration[6.0]
  def change
    add_column :proposal_topics, :cu_verified_only, :boolean, null: false, default: false
    add_column :polls, :cu_verified_only, :boolean, null: false, default: false
    add_column :budgets, :cu_verified_only, :boolean, null: false, default: false
  end
end
