class Budgets::InvestmentsListComponent < ApplicationComponent
  attr_reader :budget
  delegate :current_user, to: :helpers

  def initialize(budget)
    @budget = budget
  end

  def investments(limit: 9)
    case budget.phase
    when "accepting", "reviewing"
      results = budget.investments.confirmed
    when "selecting", "valuating"
      results = budget.investments.confirmed.feasible
    when "publishing_prices"
      results = budget.investments.confirmed.selected.feasible
    when "balloting", "reviewing_ballots"
      results = budget.investments.confirmed.selected
    when "finished"
      results = budget.investments.confirmed.feasible
    else
      results = budget.investments.confirmed
    end

    return Kaminari.paginate_array(results.order(winner: :desc, created_at: :desc)).page(params[:page])
  end

  def see_all_path
    if budget.single_heading?
      budget_investments_path(budget)
    else
      budget_groups_path(budget)
    end
  end
end
