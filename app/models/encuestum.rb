class Encuestum < ApplicationRecord
    has_one_attached :image, :dependent => :destroy
    belongs_to :main_theme
    has_many :encuestum_neighbor_types
    has_many :neighbor_types, through: :encuestum_neighbor_types
end
