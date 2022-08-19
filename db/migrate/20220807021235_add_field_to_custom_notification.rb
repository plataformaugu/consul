class AddFieldToCustomNotification < ActiveRecord::Migration[5.2]
  def change
    add_column :custom_notifications, :model, :string
    add_column :custom_notifications, :model_id, :integer
  end
end
