class PollSector < ApplicationRecord
    belongs_to :sector
    belongs_to :poll
end