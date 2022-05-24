class ProposalNeighborType < ApplicationRecord
    belongs_to :neighbor_type
    belongs_to :proposal
end
