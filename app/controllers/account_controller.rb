class AccountController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account
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
    user_token = params[:state]
    is_valid = current_user.is_token_valid?(user_token)
    clave_unica = ClaveUnica.new

    if not is_valid
      redirect_to account_path, alert: "Ocurrió un problema al verificar tus datos. Inténtalo más tarde o contacta con nosotros."
      return
    else
      code = params[:code]
      access_token = clave_unica.get_access_token(current_user, code)

      if access_token.nil?
        redirect_to account_path, alert: "Ocurrió un problema al verificar tus datos. Inténtalo más tarde o contacta con nosotros."
        return
      end

      user_information = clave_unica.get_user_information(access_token)
      current_user.cu_confirmed_at = Time.now
      current_user.save!
      redirect_to account_path, notice: "¡Tu cuenta ha sido verificada!"
    end
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
