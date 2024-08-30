class ProposalTopic < ApplicationRecord
  has_one_attached :image, dependent: :destroy
  has_many :proposals, dependent: :destroy

  validates :image, :presence => true
  validate :must_have_one_organization

  scope :published, -> { where('start_date <= ?', Date.current).where.not(published_at: nil) }

  READABLE_NAME = 'Convocatoria'

  def is_expired?
    Date.current > end_date
  end

  def is_published?
    start_date <= Date.current
  end

  def is_active?
    start_date <= Date.current && Date.current <= end_date
  end

  def status
    if self.is_expired?
      'Finalizada'
    elsif !self.is_published?
      'No publicada'
    else
      'Activa'
    end
  end

  def must_have_one_organization
    if self.organizations.filter(&:present?).empty?
      errors.add(:organizations, 'Debes seleccionar al menos una organización')
      self.image = nil
    end
  end
end
