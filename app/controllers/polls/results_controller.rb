class Polls::ResultsController < ApplicationController
  skip_authorization_check

  def index
    @polls = Kaminari.paginate_array(Poll.expired.with_results.not_budget.order(created_at: :desc)).page(params[:page])
  end
end
