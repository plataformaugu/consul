class Admin::SurveysController < Admin::BaseController
  before_action :set_survey, only: [:show, :edit, :update, :destroy, :items]

  NOTICE_TEXT = "La %{type} fue %{action} correctamente."

  def index
    @type = params[:type]

    if ![Survey::TYPE_SURVEY, Survey::TYPE_POLL].include?(@type)
      redirect_to admin_root_path
    end

    @surveys = Survey.where(survey_type: @type)
  end

  def new
    @type = params[:type]

    if ![Survey::TYPE_SURVEY, Survey::TYPE_POLL].include?(@type)
      redirect_to admin_root_path
    end

    @survey = Survey.new
  end

  def edit
  end

  def create
    @survey = Survey.new(surveys_params)

    if @survey.save
      if current_user.administrator?
        @survey.published_at = Time.now
        @survey.save!
        redirect_to admin_surveys_path(type: @survey.survey_type), notice: NOTICE_TEXT % {type: Survey::READABLE_BY_TYPE[@survey.survey_type],action: 'creada'}
        return
      else
        redirect_to pending_survey_path(@survey)
        return
      end
    else
      render :new
    end
  end

  def update
    if @survey.update(surveys_params)
      redirect_to admin_surveys_path, notice: NOTICE_TEXT % {action: 'actualizada'}
    else
      render :edit
    end
  end

  def destroy
    @survey.destroy
    redirect_to admin_surveys_path, notice: NOTICE_TEXT % {action: 'eliminada'}
  end

  def items
    @items = @survey.items
  end

  private
    def set_survey
      @survey = Survey.find(params[:id])
    end

    def surveys_params
      params.require(:survey).permit(:title, :body, :image, :start_time, :end_time, :main_theme_id, :survey_type)
    end
end
