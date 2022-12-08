class Budgets::BudgetComponent < ApplicationComponent
  attr_reader :budget

  def initialize(budget)
    @budget = budget
    @heading = budget.headings.first
  end
end
