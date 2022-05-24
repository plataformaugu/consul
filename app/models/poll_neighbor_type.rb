class PollNeighborType < ApplicationRecord
    belongs_to :neighbor_type
    belongs_to :poll
end
