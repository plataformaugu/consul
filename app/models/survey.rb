class Survey < ApplicationRecord
  has_one_attached :image, :dependent => :destroy
  has_many :items, dependent: :destroy

  validate :end_time_greater_than_start_time, on: [:create, :update]
  validate :must_have_one_organization

  scope :published, -> { where('start_time <= ?', Time.current).where.not(published_at: nil) }

  READABLE_NAME = 'Votación'

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

  def must_have_one_organization
    if self.organizations.filter(&:present?).empty?
      errors.add(:organizations, 'Debes seleccionar al menos una organización')
      self.image = nil
    end
  end
end
