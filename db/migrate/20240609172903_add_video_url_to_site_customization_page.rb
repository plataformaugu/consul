class AddVideoUrlToSiteCustomizationPage < ActiveRecord::Migration[6.0]
  def change
    add_column :site_customization_pages, :video_url, :string
  end
end
