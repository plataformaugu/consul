class Event < ApplicationRecord
  has_and_belongs_to_many :users
  has_one_attached :image, :dependent => :destroy

  validate :end_time_greater_than_start_time, on: [:create, :update]

  def is_expired?
    return Time.now > self.end_time
  end

  def is_user_joined?(user)
    if user
      return user.events.exists?(id: self.id)
    else
      return false
    end
  end

  # Validations
  def end_time_greater_than_start_time
    if start_time > end_time
      errors.add(:end_time, 'La fecha de termino no puede ser inferior a la fecha de inicio.')
    end
  end

end
