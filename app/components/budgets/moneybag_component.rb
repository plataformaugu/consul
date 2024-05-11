class Budgets::MoneybagComponent < ApplicationComponent
  attr_reader :budget
  delegate :current_user, to: :helpers

  def initialize(budget)
    @budget = budget
    @heading = budget.headings.first
  end

  def get_ballot
    query = Budget::Ballot.where(user: current_user, budget: @budget)
    @ballot = @budget.balloting? ? query.first_or_create! : query.first_or_initialize
  end
end
