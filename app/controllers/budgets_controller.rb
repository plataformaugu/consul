class BudgetsController < ApplicationController
  include FeatureFlags
  include BudgetsHelper
  feature_flag :budgets

  before_action :load_budget, only: :show
  load_and_authorize_resource

  respond_to :html, :js

  def show
    redirect_to "#{url_for(budgets_path)}?budget=#{@budget.id}"
  end

  def unselected
  end

  def index
    param_budget = params['budget']

    @budgets = Budget.published.order(created_at: :desc)
    @budget = Budget.published.find_by(id: param_budget)

    if @budget.nil? && @budgets.any?
      @budget = @budgets.first
    end
  end

  private

    def load_budget
      @budget = Budget.find_by_slug_or_id! params[:id]
    end
end
