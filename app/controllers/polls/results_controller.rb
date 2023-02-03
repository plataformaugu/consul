class Polls::ResultsController < ApplicationController
  skip_authorization_check

  before_action :load_poll, except: [:index]

  def index
    @polls = Poll.expired.with_results.not_budget.order(created_at: :desc).sort_for_list(current_user)

    if @polls.any?
      redirect_to result_path(@polls.first)
    end
  end

  def show
    @polls = Poll.expired.with_results.not_budget.order(created_at: :desc).sort_for_list(current_user)
    @stats = Poll::Stats.new(@poll)
    @total_votes = @poll.voters.count
  end

  private

    def load_poll
      @poll = Poll.find_by_slug_or_id!(params[:id])
    end
end
