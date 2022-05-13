class MainTheme < ApplicationRecord
    has_many :polls
    has_many :proposals
    has_many :encuestum
end
