class NeighborhoodCouncilEvent < ApplicationRecord
  belongs_to :neighborhood_council
  has_one :event
end
