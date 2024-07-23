class Moderation::PollsController < Admin::Poll::PollsController
  layout "admin"

  before_action :authenticate_user!
  before_action :verify_moderator

  skip_authorization_check

  include ModerateActions

  def index
    @polls = Poll.where.not("starts_at <= :time", time: Time.current).where(approved_at: nil)
  end

  def show
    @poll = Poll.find(params[:id])
  end

  def edit
    @poll = Poll.find(params[:id])
  end

  def update
    if @poll.update(poll_params)
      Segmentation.generate(
        entity_name: @poll.class.name,
        entity_id: @poll.id,
        params: params
      )
      redirect_to moderation_polls_path, notice: t("flash.actions.update.poll")
    else
      render :edit
    end
  end

  def approve
    if params['selected_ids'].any?
      Poll.where(id: params['selected_ids']).update(approved_at: Time.now)

      if params['selected_ids'].length > 1
        flash[:notice] = 'Las consultas fueron marcadas como aprobadas.'
      else
        flash[:notice] = 'La consulta fue marcada como aprobada.'
      end

      redirect_to moderation_polls_path
    end
  end

  def approve_single
    poll = Poll.find(params[:id])
    poll.approved_at = Time.now
    poll.save!

    flash[:notice] = 'La consulta fue marcada como aprobada.'
    redirect_to moderation_polls_path
  end

  private
    def verify_moderator
      raise CanCan::AccessDenied unless current_user&.moderator? || current_user&.administrator?
    end

    def verify_administrator
    end
end
