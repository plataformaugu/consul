class ProposalTopic < ApplicationRecord
  has_one_attached :image, dependent: :destroy
  has_many :proposals, dependent: :destroy

  validates :image, :presence => true

  def self.published
    where('start_date <= ?', Date.current)
  end

  def segmentation
    Segmentation.find_by(entity_name: self.class.name, entity_id: self.id)
  end

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

end
