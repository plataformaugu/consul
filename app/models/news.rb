class News < ApplicationRecord
  has_one_attached :image, :dependent => :destroy
  has_one_attached :miniature, :dependent => :destroy

  belongs_to :main_theme

  has_many :news_like
  has_many :news_dislike

  # TYPES
  CITIZEN_PARTICIPATION = 'CITIZEN_PARTICIPATION'
  NEIGHBORHOOD_COUNCIL = 'NEIGHBORHOOD_COUNCIL'
  COSOC = 'COSOC'

  ALLOWED_TYPES = [
    CITIZEN_PARTICIPATION,
    NEIGHBORHOOD_COUNCIL,
    COSOC,
  ]
  TYPES_TRANSLATE = {
    CITIZEN_PARTICIPATION => 'Participación ciudadana',
    NEIGHBORHOOD_COUNCIL => 'Junta de vecinos',
    COSOC => 'COSOC',
  }

  validates :news_type, inclusion: { in: ALLOWED_TYPES }

  scope :citizen_participation, -> { where(news_type: CITIZEN_PARTICIPATION) }
  scope :neighborhood_council,  -> { where(news_type: NEIGHBORHOOD_COUNCIL) }
  scope :cosoc,                 -> { where(news_type: COSOC) }
  scope :hightlighted,          -> { where.not(highlight_until: nil).where('highlight_until >= ?', Date.current.beginning_of_day) }
  scope :not_hightlighted,      -> { where(highlight_until: nil).or(self.where('highlight_until < ?', Date.current.beginning_of_day)) }

  def news_type_translate
    TYPES_TRANSLATE[news_type]
  end

  def likes
    self.news_like.count
  end

  def dislikes
    self.news_dislike.count
  end

  def is_hightlighted?
    if self.highlight_until.present?
      return self.highlight_until >= Date.current.beginning_of_day.to_date
    else
      return false
    end
  end

  def created_at_text
    minutes_difference = ((Time.current.to_time - self.created_at.to_time) / 1.minutes).to_i
    hours_difference = ((Time.current.to_time - self.created_at.to_time) / 1.hours).to_i
    days_difference =  (Date.current - self.created_at.to_date).to_i

    if minutes_difference < 60
      if minutes_difference == 1
        return "Hace #{minutes_difference} minuto"
      else
        return "Hace #{minutes_difference} minutos"
      end
    elsif hours_difference < 24
      if hours_difference == 1
        return "Hace #{hours_difference} hora"
      else
        return "Hace #{hours_difference} horas"
      end
    elsif days_difference <= 7
      return "Hace #{days_difference} días"
    else
      return self.created_at.strftime('%d/%m/%Y')
    end
  end

  def user_like(user)
    if user.nil?
      return false
    else
      NewsLike.where(news_id: self.id, user_id: user.id).exists?
    end
  end

  def user_dislike(user)
    if user.nil?
      return false
    else
      NewsDislike.where(news_id: self.id, user_id: user.id).exists?
    end
  end
end
