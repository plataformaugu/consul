class Budgets::BudgetComponent < ApplicationComponent
  delegate :wysiwyg, :auto_link_already_sanitized_html, :render_map, :current_user, to: :helpers
  attr_reader :budget

  def initialize(budget)
    @budget = budget
  end

  def get_ballot
    query = Budget::Ballot.where(user: current_user, budget: @budget)
    return @budget.balloting? ? query.first_or_create! : query.first_or_initialize
  end

  private

    def coordinates
      return unless budget.present?

      if budget.publishing_prices_or_later? && budget.investments.selected.any?
        investments = budget.investments.selected
      else
        investments = budget.investments
      end

      MapLocation.where(investment_id: investments).map(&:json_data)
    end
end
