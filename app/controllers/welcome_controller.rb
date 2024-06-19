class WelcomeController < ApplicationController
  include RemotelyTranslatable

  skip_authorization_check
  before_action :set_user_recommendations, only: :index, if: :current_user
  before_action :authenticate_user!, only: :welcome

  layout "devise", only: :welcome

  def index
    @headers = Widget::Card.header.all
    @cards = Widget::Card.body
    @processes = [
      *ProposalTopic.published.order(created_at: :desc).limit(4),
      *Poll.created_by_admin.not_budget.visible.order(created_at: :desc).limit(4),
      *Survey.published.order(created_at: :desc).limit(4),
    ].sort_by { |record| record.created_at }.reverse.take(4)
    @informatives = [
      *Event.order(created_at: :desc).limit(4),
      *News.all.order(created_at: :desc).limit(4),
    ].sort_by { |record| record.created_at }.reverse.take(4)
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
