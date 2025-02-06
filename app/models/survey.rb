class Survey < ApplicationRecord
  has_one_attached :image, :dependent => :destroy
  has_many :items, dependent: :destroy
  belongs_to :main_theme

  validate :end_time_greater_than_start_time, on: [:create, :update]
  validate :survey_type_present, on: [:create, :update]

  scope :published, -> { where('start_time <= ?', Time.current).where.not(published_at: nil) }

  READABLE_NAME = 'Votación'
  TYPE_SURVEY = 'survey'
  TYPE_POLL = 'poll'
  READABLE_SURVEY = 'encuesta'
  READABLE_POLL = 'consulta'
  READABLE_SURVEY_PLURAL = 'encuestas'
  READABLE_POLL_PLURAL = 'consultas'
  READABLE_BY_TYPE = {
    TYPE_SURVEY => READABLE_SURVEY,
    TYPE_POLL => READABLE_POLL
  }

  def is_expired?
    Time.current > end_time
  end

  def is_active?
    start_time <= Time.current && Time.current <= end_time
  end

  def is_survey?
    survey_type == Survey::TYPE_SURVEY
  end

  def is_poll?
    survey_type == Survey::TYPE_POLL
  end
  
  def readable_name
    self.is_survey? ? Survey::READABLE_SURVEY : Survey::READABLE_POLL
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

  def survey_type_present
    if ![Survey::TYPE_SURVEY, Survey::TYPE_POLL].include?(survey_type)
      errors.add(:survey_type, 'Hay un problema interno.')
    end
  end
end
