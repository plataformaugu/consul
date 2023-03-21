class AddCoordinatesToRadiusSegmentation < ActiveRecord::Migration[5.2]
  def change
    add_column :radius_segmentations, :coordinates, :text, array: true, default: []
  end
end
