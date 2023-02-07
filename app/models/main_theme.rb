class MainTheme < ApplicationRecord
    has_many :polls
    has_many :proposals
    has_many :encuestum
    has_many :events
    has_many :news
    has_many :functional_organizations
end
