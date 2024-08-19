class Moderation::SurveysController < Admin::SurveysController
  layout "admin"

  before_action :authenticate_user!
  before_action :verify_moderator

  skip_before_action :verify_authenticity_token
  skip_authorization_check

  include ModerateActions

  def index
    @surveys = Survey.where.not('start_time <= ?', Time.current).where(approved_at: nil, rejected_at: nil)
  end

  def show
    @survey = Survey.find(params[:id])
  end

  def edit
    @survey = Survey.find(params[:id])
  end

  def update
    if @survey.update(survey_params)
      Segmentation.generate(
        entity_name: @survey.class.name,
        entity_id: @survey.id,
        params: params
      )
      redirect_to moderation_surveys_path, notice: t("flash.actions.update.poll")
    else
      render :edit
    end
  end

  def reject
    if params['selected_ids'].any?
      Survey.where(id: params['selected_ids']).update(rejected_at: Time.now)

      if params['selected_ids'].length > 1
        flash[:notice] = 'Las consultas fueron rechazadas.'
      else
        flash[:notice] = 'La consulta fue rechazada.'
      end

      redirect_to moderation_surveys_path
    end
  end

  def approve
    if params['selected_ids'].any?
      Survey.where(id: params['selected_ids']).update(approved_at: Time.now)

      if params['selected_ids'].length > 1
        flash[:notice] = 'Las consultas fueron marcadas como aprobadas.'
      else
        flash[:notice] = 'La consulta fue marcada como aprobada.'
      end

      redirect_to moderation_surveys_path
    end
  end

  def approve_single
    survey = Survey.find(params[:id])
    survey.approved_at = Time.now
    survey.save!

    flash[:notice] = 'La consulta fue marcada como aprobada.'
    redirect_to moderation_surveys_path
  end

  private
    def verify_moderator
      raise CanCan::AccessDenied unless current_user&.moderator? || current_user&.administrator?
    end

    def verify_administrator
    end
end
