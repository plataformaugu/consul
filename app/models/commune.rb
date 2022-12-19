class Commune < ApplicationRecord
  belongs_to :province
  has_many :users
end
