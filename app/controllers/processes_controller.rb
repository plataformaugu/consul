class ProcessesController < ApplicationController
  skip_authorization_check

  def index
    @processes = [
        *ProposalTopic.published,
        *Poll.created_by_admin.not_budget.visible,
        *Survey.published.all,
    ].sort_by { |record| record.created_at }.reverse
    @processes = Kaminari.paginate_array(@processes).page(params[:page])
  end
end
