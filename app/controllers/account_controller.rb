class AccountController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account

  skip_before_action :authenticate_user!, only: [:clave_unica_authentication]
  skip_before_action :set_account, only: [:clave_unica_authentication]

  load_and_authorize_resource class: "User"

  def show
    @notifications = current_user.notifications

    # Stats
    @stats = {
      proposals: {
        created: current_user.proposals.count,
        votes_received: current_user.proposals.map{|p| p.total_votes}.sum,
        votes_created: current_user.votes.where(votable_type: 'Proposal').count,
        comments: current_user.comments.where(commentable_type: 'Proposal', hidden_at: nil).count
      },
      polls: {
        answered: Poll::Voter.where(user_id: current_user.id).count,
        comments: current_user.comments.where(commentable_type: 'Poll', hidden_at: nil).count
      },
      debates: {
        created: current_user.debates.count,
        comments: current_user.comments.where(commentable_type: 'Debate', hidden_at: nil).count
      },
      budgets: {
        created: current_user.budget_investments.count,
        votes_received: current_user.budget_investments.map{|p| p.total_votes}.sum,
        votes_created: current_user.votes.where(votable_type: 'Budget::Investment').count,
        comments: current_user.comments.where(commentable_type: 'Budget::Investment', hidden_at: nil).count
      }
    }
  end

  def update
    if @account.update(account_params)
      redirect_to account_path, notice: t("flash.actions.save_changes.notice")
    else
      @account.errors.messages.delete(:organization)
      render :show
    end
  end

  def clave_unica_authentication
    clave_unica = ClaveUnica.new
    access_token = clave_unica.get_access_token(params[:code], params[:state])
    user_information = clave_unica.get_user_information(access_token)

    document_number = "#{user_information['RolUnico']['numero']}#{user_information['RolUnico']['DV']}"
    first_name = user_information['name']['nombres'][0]
    last_name = user_information['name']['apellidos'][0]

    found_user = User.find_by(document_number: document_number)

    if found_user.present?
      sign_in(:user, found_user)
    else
      user = User.new(
        document_number: document_number,
        first_name: first_name,
        last_name: last_name,
        cu_confirmed_at: Time.now,
        confirmed_at: Time.now,
      )

      user.save(validate: false)

      sign_in(:user, user)
    end

    redirect_to root_path, notice: 'Iniciaste sesión correctamente'
  end

  private

    def set_account
      @account = current_user
    end

    def account_params
      params.require(:account).permit(allowed_params)
    end

    def allowed_params
      if @account.organization?
        [:phone_number, :email_on_comment, :email_on_comment_reply, :newsletter,
         organization_attributes: [:name, :responsible_name]]
      else
        [:username, :public_activity, :public_interests, :email_on_comment,
         :email_on_comment_reply, :email_on_direct_message, :email_digest, :newsletter,
         :official_position_badge, :recommended_debates, :recommended_proposals, :gender, :social_organization, :commune_id]
      end
    end
end
