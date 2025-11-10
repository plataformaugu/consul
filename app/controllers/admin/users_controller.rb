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

  def export_csv
    current_month_start = Date.current.beginning_of_month
    current_month_end = Date.current.end_of_month
    
    @users = User.where(
      "(current_sign_in_at >= ? AND current_sign_in_at <= ?) OR 
       (last_sign_in_at >= ? AND last_sign_in_at <= ?) OR 
       (created_at >= ? AND created_at <= ?)",
      current_month_start, current_month_end,
      current_month_start, current_month_end,
      current_month_start, current_month_end
    )
    
    csv_data = generate_current_month_active_users_csv(@users)
    
    send_data(
      csv_data, 
      filename: "usuarios_activos_#{I18n.l(Date.current, format: '%B_%Y')}.csv",
      type: 'text/csv',
    )
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

    def generate_current_month_active_users_csv(users)
      CSV.generate(headers: true) do |csv|
        csv << ['ID', 'Fecha último inicio de sesión', 'Fecha de registro', 'Fecha de confirmación']
        
        users.find_each do |user|
          last_login = [user.current_sign_in_at, user.last_sign_in_at].compact.max
          
          csv << [
            user.id,
            last_login ? last_login.strftime('%Y-%m-%d %H:%M:%S.%6N') : '',
            user.created_at ? user.created_at.strftime('%Y-%m-%d %H:%M:%S.%6N') : '',
            user.confirmed_at ? user.confirmed_at.strftime('%Y-%m-%d %H:%M:%S.%6N') : ''
          ]
        end
      end
    end
end
