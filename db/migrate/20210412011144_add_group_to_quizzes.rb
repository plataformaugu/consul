class AddGroupToQuizzes < ActiveRecord::Migration[5.2]
  def change
    add_reference :quizzes, :group, foreign_key: true
  end
end
