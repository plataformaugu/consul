class Encuestum < ApplicationRecord
    has_one_attached :image, :dependent => :destroy
    belongs_to :main_theme
end
