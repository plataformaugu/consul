class WelcomeController < ApplicationController
  include RemotelyTranslatable

  skip_authorization_check
  before_action :set_user_recommendations, only: :index, if: :current_user
  before_action :authenticate_user!, only: :welcome

  layout "devise", only: :welcome

  def index
    @headers = Widget::Card.header.all
    @proposals = Proposal.published.order(created_at: :desc).limit(3)
    @polls = Poll.created_by_admin.not_budget.visible.order(created_at: :desc).limit(3)

    hidden_survey_ids = [10]
    @surveys = Survey.published.where.not(id: hidden_survey_ids).order(created_at: :desc).limit(3)

    @debates = Debate.published.order(created_at: :desc).limit(3)
    @events = Event.order(created_at: :desc).limit(3)
    @cards = Widget::Card.body

    fake_budget = Survey.published.where(id: 10).first
    third_last_budgets = Budget.published.order(created_at: :desc).limit(3).to_a

    if fake_budget.present?
      third_last_budgets.append(fake_budget)
    end

    @budgets = third_last_budgets.sort_by(&:created_at).reverse[..2]
  end

  def welcome
    redirect_to root_path
  end

  private

    def set_user_recommendations
      @recommended_debates = Debate.recommendations(current_user).sort_by_recommendations.limit(3)
      @recommended_proposals = Proposal.recommendations(current_user).sort_by_recommendations.limit(3)
    end
end
