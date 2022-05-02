class MainTheme < ApplicationRecord
    has_many :polls
    has_many :proposals
end
