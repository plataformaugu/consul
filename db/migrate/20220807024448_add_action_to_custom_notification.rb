class AddActionToCustomNotification < ActiveRecord::Migration[5.2]
  def change
    add_column :custom_notifications, :action, :string
    remove_column :custom_notifications, :title_field
  end
end
