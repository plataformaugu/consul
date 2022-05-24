class ProposalsThemeNeighborType < ApplicationRecord
    belongs_to :neighbor_type
    belongs_to :proposal_theme
end
