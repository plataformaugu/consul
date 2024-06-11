class Survey < ApplicationRecord
  has_one_attached :image, :dependent => :destroy
  has_many :items, dependent: :destroy

  def answered_by_user?(user)
    items_answered_by_user = self.items.map { |survey_item| survey_item.answers.exists?(user_id: user.id) }
    
    return items_answered_by_user.all?
  end
end
