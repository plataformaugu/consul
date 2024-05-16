class Budgets::BudgetComponent < ApplicationComponent
  attr_reader :budget
  delegate :current_user, to: :helpers

  def initialize(budget, can_participate, reason)
    @budget = budget
    @heading = budget.headings.first
    @can_participate = can_participate
    @reason = reason
  end
end
