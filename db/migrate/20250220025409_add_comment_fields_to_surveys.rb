class AddCommentFieldsToSurveys < ActiveRecord::Migration[5.2]
  def change
    add_column :surveys, :comments_count, :integer, default: 0
  end
end
