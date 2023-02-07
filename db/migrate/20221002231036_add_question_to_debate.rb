class AddQuestionToDebate < ActiveRecord::Migration[5.2]
  def change
    add_column :debates, :question, :string
  end
end
