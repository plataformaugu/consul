class Budgets::UnselectedListComponent < ApplicationComponent
  attr_reader :budget

  def initialize(budget)
    @budget = budget
  end

  def investments(limit: 9)
    case @budget.phase
    when 'publishing_prices'
      results = budget.investments.published.unselected
    when 'selecting'
      results = budget.investments.published.not_feasible
    end

    Kaminari.paginate_array(results.order(created_at: :desc)).page(params[:page])
  end
end
