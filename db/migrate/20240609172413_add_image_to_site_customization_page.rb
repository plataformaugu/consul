class AddImageToSiteCustomizationPage < ActiveRecord::Migration[6.0]
  def change
    add_column :site_customization_pages, :image, :string
  end
end
