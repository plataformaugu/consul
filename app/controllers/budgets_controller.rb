class BudgetsController < ApplicationController
  include FeatureFlags
  include BudgetsHelper
  feature_flag :budgets

  before_action :load_budget, only: :show
  load_and_authorize_resource

  respond_to :html, :js

  def show
    raise ActionController::RoutingError, "Not Found" unless budget_published?(@budget)

    @can_participate = true
    @reason = nil

    if current_user && !current_user.administrator? && @budget.segmentation.present?
      @can_participate, @reason = @budget.segmentation.validate(current_user)
    end
  end

  def unselected
  end

  def index
    fake_budgets = Survey.published.where(id: 10)
    @budgets = Kaminari.paginate_array(fake_budgets + Budget.published).page(params[:page]).per(9)
  end

  private

    def load_budget
      @budget = Budget.find_by_slug_or_id! params[:id]
    end
end
