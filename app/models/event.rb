class Event < ApplicationRecord
  has_and_belongs_to_many :users
  has_one_attached :image, :dependent => :destroy

  def is_expired?
    return Time.now > self.start_time
  end

  def is_user_joined?(user)
    if user
      return user.events.exists?(id: self.id)
    else
      return false
    end
  end
end
