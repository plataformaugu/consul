class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [:show]

  load_and_authorize_resource

  has_filters %w[active erased], only: :index

  def index
    @users = @users.send(@current_filter)
    @users = @users.by_username_email_or_document_number(params[:search]) if params[:search]
    @users = @users.page(params[:page])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    # Stats
    @stats = {
      proposals: {
        created: @user.proposals.count,
        votes_received: @user.proposals.map{|p| p.total_votes}.sum,
        votes_created: @user.votes.where(votable_type: 'Proposal').count,
        comments: @user.comments.where(commentable_type: 'Proposal', hidden_at: nil).count
      },
      polls: {
        answered: Poll::Voter.where(user_id: @user.id).count,
        comments: @user.comments.where(commentable_type: 'Poll', hidden_at: nil).count
      },
      debates: {
        created: @user.debates.count,
        comments: @user.comments.where(commentable_type: 'Debate', hidden_at: nil).count
      },
      budgets: {
        created: @user.budget_investments.count,
        votes_received: @user.budget_investments.map{|p| p.total_votes}.sum,
        votes_created: @user.votes.where(votable_type: 'Budget::Investment').count,
        comments: @user.comments.where(commentable_type: 'Budget::Investment', hidden_at: nil).count
      }
    }
  end

  private
    def set_user
      @user = User.find(params[:id])
    end
end
