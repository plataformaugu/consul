class DebateNeighborType < ApplicationRecord
    belongs_to :neighbor_type
    belongs_to :debate
end
