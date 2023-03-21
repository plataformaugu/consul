class Encuestum < ApplicationRecord
    has_one_attached :image, :dependent => :destroy
    belongs_to :main_theme
    has_many :encuestum_neighbor_types
    has_many :neighbor_types, through: :encuestum_neighbor_types

    def segmentation
        Segmentation.find_by(entity_name: self.class.name, entity_id: self.id)
    end

    def is_visible?
        if self.start_date.present?
            self.start_date <= Date.current.beginning_of_day
        else
            return true
        end
    end

    def is_active?
        if self.start_date.present?
            self.start_date <= Date.current.beginning_of_day && Date.current.beginning_of_day <= self.limit_date
        else
            Date.current.beginning_of_day <= self.limit_date
        end
    end
end
