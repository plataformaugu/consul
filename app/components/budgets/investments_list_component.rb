class Budgets::InvestmentsListComponent < ApplicationComponent
  attr_reader :budget

  def initialize(budget)
    @budget = budget
  end

  def investments(limit: 9)
    case budget.phase
    when "accepting", "reviewing"
      results = budget.investments.published
    when "selecting", "valuating"
      results = budget.investments.published.feasible
    when "publishing_prices"
      results = budget.investments.published.selected.feasible
    when "balloting", "reviewing_ballots"
      results = budget.investments.published.selected
    when "finished"
      results = budget.investments.published.selected.feasible
    else
      results = budget.investments.published
    end

    Kaminari.paginate_array(results.order(winner: :desc, created_at: :desc)).page(params[:page])
  end

  def see_all_path
    if budget.single_heading?
      budget_investments_path(budget)
    else
      budget_groups_path(budget)
    end
  end
end
