class Ballot < ApplicationRecord
  belongs_to :user

  has_many :ballot_answers

  BALLOT_UNIQUE = 'Voto único'
  BALLOT_PRIORIZATION = 'Priorización'
  BALLOT_MULTIPLE = 'Voto múltiple'
  BALLOT_OPEN_ANSWER = 'Respuesta abierta'
  BALLOT_TYPES = [
    BALLOT_UNIQUE,
    BALLOT_PRIORIZATION,
    BALLOT_MULTIPLE,
    BALLOT_OPEN_ANSWER,
  ]

  def component
    case self.ballot_type
    when BALLOT_UNIQUE
      Ballots::UniqueAnswer.new(self)
    when BALLOT_MULTIPLE
      Ballots::MultipleAnswer.new(self)
    when BALLOT_PRIORIZATION
      Ballots::PriorizationAnswer.new(self)
    when BALLOT_OPEN_ANSWER
      Ballots::OpenAnswer.new(self)
    end
  end

  def voted_by?(user)
    return user.present? && BallotAnswer.where(ballot: self, user: user).exists?
  end
end
