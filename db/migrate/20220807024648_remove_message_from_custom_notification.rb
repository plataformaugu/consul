class RemoveMessageFromCustomNotification < ActiveRecord::Migration[5.2]
  def change
    remove_column :custom_notifications, :message
  end
end
