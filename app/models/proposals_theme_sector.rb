class ProposalsThemeSector < ApplicationRecord
    belongs_to :sector
    belongs_to :proposals_theme
end
