class AddIsActiveToQuizzes < ActiveRecord::Migration[5.2]
  def change
    add_column :quizzes, :is_active, :boolean, :default => true
  end
end
