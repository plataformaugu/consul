class Sector < ApplicationRecord
    has_many :users

    has_many :proposal_sectors
    has_many :proposals, through: :proposal_sectors
    has_many :neighborhood_councils
end
