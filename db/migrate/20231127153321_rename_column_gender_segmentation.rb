class RenameColumnGenderSegmentation < ActiveRecord::Migration[6.0]
  def change
    rename_column :gender_segmentations, :type, :gender
  end
end
