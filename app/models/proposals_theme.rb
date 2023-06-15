class ProposalsTheme < ApplicationRecord
  has_one_attached :image, :dependent => :destroy
  has_many :proposals_theme_sectors
  has_many :proposals_theme_neighbor_types
  has_many :sectors, through: :proposals_theme_sectors
  has_many :neighbor_types, through: :proposals_theme_neighbor_types
  has_many :proposals

  def segmentation
    Segmentation.find_by(entity_name: self.class.name, entity_id: self.id)
  end

  def everyone_can_vote?
    if Set.new(['Vecino Residente Las Condes', 'Vecino Flotante Las Condes', 'Registrado sin Tarjeta Vecino']) == Set.new(self.neighbor_types.pluck(:name))
      return true
    elsif Set.new(['Registrado sin Tarjeta Vecino']) == Set.new(self.neighbor_types.pluck(:name))
      return true
    else
      return false
    end
  end

  def get_restriction_message
    user_types = 'todos'

    if self.sectors.any? or Set.new(['Vecino Residente Las Condes']) == Set.new(self.neighbor_types.pluck(:name))
      user_types = 'vecinos residentes'
    elsif Set.new(['Vecino Residente Las Condes', 'Vecino Flotante Las Condes']) == Set.new(self.neighbor_types.pluck(:name))
      user_types = 'vecinos residentes y flotantes'
    elsif Set.new(['Vecino Flotante Las Condes']) == Set.new(self.neighbor_types.pluck(:name))
      user_types = 'vecinos flotantes'
    end

    if self.sectors.any?
      inner_message = self.sectors.map{ |s| s.name }.join(', ')
      return "Este proceso está habilitado solo para <br>residentes de la(s) unidad(es) vecinal(es):<br><strong>#{inner_message}.</strong>"
    else
      return "Este proceso está habilitado solo para<br><strong>#{user_types}</strong>"
    end

    return ''
  end

  def is_expired?
    Date.current.beginning_of_day > self.end_date.beginning_of_day
  end

  def can_user_vote?(user)
    if not user
      return false
    end

    if self.sectors.any?
      if not self.sectors.include?(user.sector) or not user.neighbor_type or user.neighbor_type.name != 'Vecino Residente Las Condes'
        return false
      else
        return true
      end
    else
      return self.neighbor_types.include?(user.neighbor_type)
    end

    return false
  end

  def finished?
    Date.current > self.end_date
  end
end
