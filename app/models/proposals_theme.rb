class ProposalsTheme < ApplicationRecord
    has_one_attached :image, :dependent => :destroy
    has_many :proposals_theme_sectors
    has_many :sectors, through: :proposals_theme_sectors
    has_many :proposals
end
