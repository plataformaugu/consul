class Budgets::BudgetComponent < ApplicationComponent
  attr_reader :budget
  delegate :current_user, to: :helpers

  def initialize(budget)
    @budget = budget
    @heading = budget.headings.first
  end
end
