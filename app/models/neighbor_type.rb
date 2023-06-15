class NeighborType < ApplicationRecord
    has_many :users

    has_many :proposals, through: :proposals_neighbor_types
    has_many :proposals_themes, through: :proposals_theme_neighbor_types
    has_many :polls, through: :poll_neighbor_types
    has_many :encuestum, through: :encuesta_neighbor_types

    has_and_belongs_to_many :segmentations
end
