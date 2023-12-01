class BallotAnswer < ApplicationRecord
  belongs_to :ballot
  belongs_to :user
end
