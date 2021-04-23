class QuizzesController < ApplicationController
  before_action :set_quiz, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create]
  has_orders %w[most_voted newest oldest], only: :show
  skip_authorization_check

  # GET /quizzes
  def index
    redirect_to root_path
  end

  # GET /quizzes/1
  def show
    redirect_to root_path
  end

  # GET /quizzes/new
  def new
    unless params['step'].present? 
      if Quiz.where(user_id: current_user.id, name: 'TMP').exists?
        Quiz.where(user_id: current_user.id, name: 'TMP').destroy_all
      end
    else
      if params['step'].to_i == 1
        if Quiz.where(user_id: current_user.id, name: 'TMP').exists?
          Quiz.where(user_id: current_user.id, name: 'TMP').destroy_all
        end
      end
    end

    @quiz = Quiz.new
    @title = 'Cuestionario'
  end

  # GET /quizzes/1/edit
  def edit
    redirect_to root_path
  end

  # POST /quizzes
  def create
    @visible = nil

    if params[:quiz].present?
      @visible = params[:quiz][:visible]
      params.delete('quiz')
    end

    params.delete('utf8')
    params.delete('authenticity_token')
    params.delete('controller')
    params.delete('action')

    @type = nil

    if params.key?('type')
      @type = params['type']
      params.delete('type')
    end

    @quiz = Quiz.find(params['quiz_id'])
    params.delete('quiz_id')

    @step = params['step']
    params.delete('step')

    @quiz['q%s' % [@step]] = params.to_enum.to_h
    
    unless @visible.nil?
      @quiz.visible = @visible == '1' ? true : false
    end

    unless @type.nil?
      if @type == 'grupal'
        @quiz.group_id = params['group']
        params.delete('group')
      end
    end

    @quiz.save

    if ['1', '2', '3'].include?(@step)
      if @quiz.group_id.nil?
        redirect_to new_quiz_path(step: (@step.to_i + 1).to_s, quiz_id: @quiz.id)
      else
        redirect_to new_quiz_path(step: (@step.to_i + 1).to_s, quiz_id: @quiz.id, group: @quiz.group_id)
      end
    else
      @quiz.name = ''
      @quiz.save
      @title_text = 'Finalizaste la encuesta'
      render 'success'
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

  def monitoring
    @quizzes = Quiz.all
    render :monitoring
  end

  def vote
    quiz_id = params['quiz_id']

    unless Vote.where(votable_type: "Quiz", votable_id: quiz_id.to_i, voter_id: current_user.id).exists?
      vote = Vote.new(votable_type: "Quiz", votable_id: quiz_id.to_i, voter_id: current_user.id, vote_weight: 1)
      vote.save
    else
      redirect root_path
    end
  end

  def set_invisible
    quiz_id = params['quiz_id']

    @quiz = Quiz.find(quiz_id.to_i)

    if @quiz.quiz_type == 1
      @quiz_type = 'diagnóstico'
    else
      @quiz_type = 'sugerencia'
    end

    Mailer.removed_content(@quiz.user.email, 'participación').deliver_later

    @quiz.visible = false
    @quiz.save
  end

  def invite_user
    Mailer.user_invite(params[:email]).deliver_later
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_quiz
      @quiz = Quiz.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def quiz_params
      params.require(:quiz).permit(:name, :description, :user_id, :visible, :q1, :q2, :q3, :q4, :q5, :quiz_type, :tag_id)
    end
end
