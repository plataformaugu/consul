class BudgetsController < ApplicationController
  include FeatureFlags
  include BudgetsHelper
  feature_flag :budgets

  before_action :load_budget, only: :show
  load_and_authorize_resource

  respond_to :html, :js

  def show
    raise ActionController::RoutingError, "Not Found" unless budget_published?(@budget)
  end

  def unselected
  end

  def index
    @budgets = Kaminari.paginate_array(Budget.published).page(params[:page]).per(9)
  end

  private

    def load_budget
      @budget = Budget.find_by_slug_or_id! params[:id]
    end
end
