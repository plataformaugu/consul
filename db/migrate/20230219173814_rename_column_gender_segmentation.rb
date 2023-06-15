class RenameColumnGenderSegmentation < ActiveRecord::Migration[5.2]
  def change
    rename_column :gender_segmentations, :type, :gender
  end
end
