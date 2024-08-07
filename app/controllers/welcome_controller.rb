class WelcomeController < ApplicationController
  include RemotelyTranslatable

  skip_authorization_check
  before_action :set_user_recommendations, only: :index, if: :current_user
  before_action :authenticate_user!, only: :welcome

  layout "devise", only: :welcome

  def index
    @headers = Widget::Card.header.all
    @cards = Widget::Card.body

    proposal_topics = ProposalTopic.published.order(created_at: :desc).limit(4)
    polls = Poll.created_by_admin.not_budget.visible.published.order(created_at: :desc).limit(4)
    surveys = Survey.published.order(created_at: :desc).limit(4)

    if current_user && !current_user.without_organization?
      proposal_topics = ProposalTopic.published.order(created_at: :desc).where(
        ':organizations = ANY (organizations)',
        organizations: current_user.organization_name,
      ).limit(4)
      polls = Poll.created_by_admin.not_budget.visible.published.order(created_at: :desc).where(
        ':organizations = ANY (organizations)',
        organizations: current_user.organization_name,
      ).limit(4)
      surveys = Survey.published.order(created_at: :desc).where(
        ':organizations = ANY (organizations)',
        organizations: current_user.organization_name,
      ).limit(4)
    end

    @processes = [
      *proposal_topics,
      *polls,
      *surveys,
    ].sort_by { |record| record.created_at }.reverse.take(4)
    @informatives = [
      *Event.published.order(created_at: :desc).limit(4),
      *News.published.order(created_at: :desc).limit(4),
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
