class AddReferenceToNewsInLikeAndDislike < ActiveRecord::Migration[5.2]
  def change
    add_reference :news_like, :news, index: true
    add_reference :news_dislike, :news, index: true
  end
end
