class Event < ApplicationRecord
    has_and_belongs_to_many :users
    belongs_to :main_theme
    
    belongs_to :neighborhood_council_event
end
