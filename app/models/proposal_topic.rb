class ProposalTopic < ApplicationRecord
  has_one_attached :image, dependent: :destroy
  has_many :proposals, dependent: :destroy
  has_and_belongs_to_many :communes

  validates :image, :presence => true

  def self.published
    where('start_date <= ?', Date.current)
  end

  def can_participate?(user)
    user and (self.all_communes? or self.communes.include?(user.commune))
  end

  def cant_participate_reason(user)
    if !(self.all_communes? or self.communes.include?(user.commune))
      return "Este proceso está solo habilitado para las comunas: #{self.communes.pluck(:name).join(", ")}"
    end
  end

  def all_communes?
    self.communes.count == Commune.count or self.communes.count == 0
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
