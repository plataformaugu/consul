class CreateQuizzes < ActiveRecord::Migration[5.2]
  def change
    create_table :quizzes do |t|
      t.string :name
      t.text :description
      t.boolean :visible, :default => true
      t.string :q1
      t.string :q2
      t.string :q3
      t.string :q4
      t.string :q5
      t.integer :quiz_type
      t.references :user, foreign_key: true
      t.references :tag, foreign_key: true

      t.timestamps
    end
  end
end
