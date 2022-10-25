class Budgets::UnselectedListComponent < ApplicationComponent
    attr_reader :budget
  
    def initialize(budget)
      @budget = budget
    end

    def investments(limit: 9)
      case @budget.phase
      when 'publishing_prices'
        return Kaminari.paginate_array(budget.investments.unselected.order(created_at: :desc)).page(params[:page])
      when 'selecting'
        return Kaminari.paginate_array(budget.investments.not_feasible.order(created_at: :desc)).page(params[:page])
      end
    end
  end
