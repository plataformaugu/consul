class MacroTerritory < ApplicationRecord
    has_and_belongs_to_many :sectors
    has_and_belongs_to_many :segmentations
end
