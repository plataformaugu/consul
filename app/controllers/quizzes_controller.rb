class QuizzesController < ApplicationController
  before_action :set_quiz, only: [:show, :edit, :update, :destroy]
  skip_authorization_check

  # GET /quizzes
  def index
    @quizzes = Quiz.all
    redirect_to root_path
  end

  # GET /quizzes/1
  def show
    redirect_to root_path
  end

  # GET /quizzes/new
  def new
    @quiz = Quiz.new
    @title = ''
    
    if params[:type].present?
      unless ['1', '2'].include? params[:type]
        redirect_to root_path
      end

      @type = params[:type].to_i
      if @type == 1
        unless params[:chapter].present?
          redirect_to root_path
        else
          if Tag.category.where(id: params[:chapter].to_i).exists?
            @chapter = Tag.category.find(params[:chapter].to_i)
            @title = 'Diagnósticos de acción por tema'
          else
            redirect_to root_path
          end
        end
      end
      if @type == 2
        if params[:chapter].present?
          redirect_to root_path
        else
          @title = 'Sugerencias de mecanismos de monitoreo'
        end
      end
    else
      redirect_to root_path
    end
  end

  # GET /quizzes/1/edit
  def edit
    redirect_to root_path
  end

  # POST /quizzes
  def create
    new_params = quiz_params
    new_params['q1'] = params['quiz']['q1'] == 'Otro' ? params['quiz']['q5'] : params['quiz']['q1']
    new_params['q2'] = params['quiz']['q2']
    new_params['q3'] = params['quiz']['q3']
    new_params['q4'] = params['q4'].present? ? params['q4'].join(', ') : ''
    new_params['user'] = current_user
    new_params.delete('q5')

    @quiz = Quiz.new(new_params)

    if @quiz.save
      redirect_to @quiz, notice: 'Quiz was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /quizzes/1
  def update
    if @quiz.update(quiz_params)
      redirect_to @quiz, notice: 'Quiz was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /quizzes/1
  def destroy
    @quiz.destroy
    redirect_to quizzes_url, notice: 'Quiz was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quiz
      @quiz = Quiz.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def quiz_params
      params.require(:quiz).permit(:name, :description, :user_id, :visible, :q1, :q2, :q3, :q4, :q5, :quiz_type)
    end
end
