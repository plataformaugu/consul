class Sector < ApplicationRecord
    has_many :users

    has_many :proposal_sectors
    has_many :proposals, through: :proposal_sectors
    has_many :neighborhood_councils

    has_and_belongs_to_many :macro_territories
    has_and_belongs_to_many :segmentations
end
