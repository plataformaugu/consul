class Admin::SurveysController < Admin::BaseController
  before_action :set_survey, only: [:show, :edit, :update, :destroy, :items]

  NOTICE_TEXT = "La encuesta fue %{action} correctamente."

  def index
    @surveys = Survey.all
  end

  def new
    @survey = Survey.new
  end

  def edit
  end

  def create
    @survey = Survey.new(surveys_params)

    if @survey.save
      redirect_to admin_surveys_path, notice: NOTICE_TEXT % {action: 'creada'}
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
      params.require(:survey).permit(:title, :body, :image)
    end
end
