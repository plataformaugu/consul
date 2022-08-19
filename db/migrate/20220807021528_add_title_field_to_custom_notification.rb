class AddTitleFieldToCustomNotification < ActiveRecord::Migration[5.2]
  def change
    add_column :custom_notifications, :title_field, :string
  end
end
