class Survey < ApplicationRecord
  has_one_attached :image, :dependent => :destroy
  has_many :items, dependent: :destroy

  validate :end_time_greater_than_start_time, on: [:create, :update]

  scope :published, -> { where('start_time <= ?', Time.current) }

  def segmentation
    Segmentation.find_by(entity_name: self.class.name, entity_id: self.id)
  end

  def is_expired?
    Time.current > end_time
  end

  def is_active?
    start_time <= Time.current && Time.current <= end_time
  end

  def answered_by_user?(user)
    items_answered_by_user = self.items.map { |survey_item| survey_item.answers.exists?(user_id: user.id) }

    return items_answered_by_user.all?
  end

  def end_time_greater_than_start_time
    if start_time > end_time
      errors.add(:end_time, 'La fecha de termino no puede ser inferior a la fecha de inicio.')
    end
  end
end
