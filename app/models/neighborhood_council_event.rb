class NeighborhoodCouncilEvent < ApplicationRecord
  has_and_belongs_to_many :users
  belongs_to :neighborhood_council
end
