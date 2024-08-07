class ProcessesController < ApplicationController
  skip_authorization_check

  def index
    proposal_topics = ProposalTopic.published
    polls = Poll.created_by_admin.not_budget.visible.published
    surveys = Survey.published

    if current_user && !current_user.without_organization?
      proposal_topics = ProposalTopic.published.where(
        ':organizations = ANY (organizations)',
        organizations: current_user.organization_name,
      )
      polls = Poll.created_by_admin.not_budget.visible.published.where(
        ':organizations = ANY (organizations)',
        organizations: current_user.organization_name,
      )
      surveys = Survey.published.where(
        ':organizations = ANY (organizations)',
        organizations: current_user.organization_name,
      )
    end

    @processes = [
      *proposal_topics,
      *polls,
      *surveys,
    ].sort_by { |record| record.created_at }.reverse
    @processes = Kaminari.paginate_array(@processes).page(params[:page])
  end
end
