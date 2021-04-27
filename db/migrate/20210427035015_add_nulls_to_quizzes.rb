class AddNullsToQuizzes < ActiveRecord::Migration[5.2]
  def change
    change_column :quizzes, :name, :string, :null => true
    change_column :quizzes, :description, :string, :null => true
  end
end
