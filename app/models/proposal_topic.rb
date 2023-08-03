class ProposalTopic < ApplicationRecord
  has_one_attached :image, dependent: :destroy
  has_many :proposals, dependent: :destroy
  has_and_belongs_to_many :communes

  validates :image, :presence => true

  def self.published
    where('start_date <= ?', Date.current)
  end

  def can_participate?(user)
    can_participate = false

    if user
      can_participate = (self.all_communes? || self.communes.include?(user.commune)) && (!self.cu_verified_only || (self.cu_verified_only && user.is_cu_confirmed?))
    end

    return can_participate
  end

  def cant_participate_reason(user)
    if user
      if self.cu_verified_only && !user.is_cu_confirmed?
        return 'Este proceso está habilitado solo para usuarios verificados por Clave Única. Ingresa a <a href="/account">"Mi Cuenta"</a> para verificar tu cuenta.'
      end

      if !(self.all_communes? || self.communes.include?(user.commune))
        return "Este proceso está solo habilitado para las comunas: #{self.communes.pluck(:name).join(", ")}"
      end
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
