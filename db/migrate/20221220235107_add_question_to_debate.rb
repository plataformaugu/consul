class AddQuestionToDebate < ActiveRecord::Migration[6.0]
  def change
    add_column :debates, :question, :string
  end
end
