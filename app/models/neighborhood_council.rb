class NeighborhoodCouncil < ApplicationRecord
  belongs_to :sector

  has_many :directives
  has_many :neighborhood_council_events
  has_many :news
end
