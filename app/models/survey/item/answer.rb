class Survey::Item::Answer < ApplicationRecord
  belongs_to :survey_item, foreign_key: 'survey_item'
  belongs_to :user
end
