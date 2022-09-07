class CreateCustomNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :custom_notifications do |t|
      t.string :message

      t.timestamps
    end
  end
end
