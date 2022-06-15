class AddWebBrowserToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :web_browser, :string
  end
end
