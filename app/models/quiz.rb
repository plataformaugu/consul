class Quiz < ApplicationRecord
  belongs_to :user
  belongs_to :tag

  def register_vote(user, vote_value)
    if votable_by?(user) && !archived?
      vote_by(voter: user, vote: vote_value)
    end
  end

  def votes
    Vote.where(votable_type: "Quiz", votable_id: self.id).count
  end

  def voters
    User.active.where(id: votes_for.voters)
  end
end
