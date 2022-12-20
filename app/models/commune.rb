class Commune < ApplicationRecord
  belongs_to :province
  has_many :users
  has_and_belongs_to_many :debates
  has_and_belongs_to_many :polls
  has_and_belongs_to_many :proposal_topics
  has_and_belongs_to_many :budgets
end
