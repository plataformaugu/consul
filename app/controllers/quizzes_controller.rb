class QuizzesController < ApplicationController
  before_action :set_quiz, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create]
  has_orders %w[most_voted newest oldest], only: :show
  skip_authorization_check

  # GET /quizzes
  def index
    if current_user.is_individual.nil?
      redirect_to root_path
    end
    @quizzes = Quiz.all
    redirect_to root_path
  end

  # GET /quizzes/1
  def show
    redirect_to root_path
  end

  # GET /quizzes/new
  def new
    if current_user.is_individual.nil?
      redirect_to root_path
    end
    @quiz = Quiz.new
    @title = ''
    
    if params[:type].present?
      unless ['1', '2', '3'].include? params[:type]
        redirect_to root_path
      end

      @type = params[:type].to_i
      if @type == 1
        unless self.is_user_allowed(@type)
          redirect_to root_path
        end

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
        unless self.is_user_allowed(@type)
          redirect_to root_path
        end

        if params[:chapter].present?
          redirect_to root_path
        else
          @title = 'Sugerencias de mecanismos de monitoreo'
        end
      end
      if @type == 3
        unless self.is_user_allowed(@type)
          redirect_to root_path
        end

        unless params[:chapter].present?
          redirect_to root_path
        else
          if Tag.category.where(id: params[:chapter].to_i).exists?
            @chapter = Tag.category.find(params[:chapter].to_i)
            @title = 'Sugerencias de acciones por tema'
          else
            redirect_to root_path
          end
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
    new_params['user'] = current_user

    if quiz_params['quiz_type'] == '1'
      new_params['q1'] = params['quiz']['q1'] == 'Otro' ? params['quiz']['q5'] : params['quiz']['q1']
      new_params['q2'] = params['quiz']['q2']
      new_params['q3'] = params['quiz']['q3']
      new_params['q4'] = params['q4'].present? ? params['q4'].join(', ') : ''
      new_params.delete('q5')

      if new_params['tag_id'].present? and Tag.category.exists?(id: new_params['tag_id'].to_i)
        @quiz = Quiz.new(new_params)

        if @quiz.save
          @title_text = 'Diagnóstico enviado correctamente'
          @send_text = 'Enviar otro diagnóstico'
          @show_next_button = true
          @chapter = new_params['tag_id']
          @type = new_params['quiz_type']
          render :success
        else
          render :new
        end
      else
        render :new
      end
    elsif quiz_params['quiz_type'] == '2'
      new_params['q3'] = params['q3'].present? ? params['q3'].join(', ') : ''
      @quiz = Quiz.new(new_params)

      if @quiz.save
        @title_text = 'Monitoreo enviado correctamente'
        @send_text = 'Enviar otra monitoreo'
        @chapter = nil
        @type = new_params['quiz_type']
        render :success
      else
        render :new
      end
    elsif quiz_params['quiz_type'] == '3'
      @quiz = Quiz.new(new_params)

      if @quiz.save
        @title_text = 'Sugerencia enviada correctamente'
        @send_text = 'Enviar otra sugerencia'
        @chapter = new_params['tag_id']
        @type = new_params['quiz_type']
        render :success
      else
        render :new
      end
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

  def is_user_allowed(quiz_type)
    count = Quiz.where(quiz_type: quiz_type).where(user_id: current_user.id).count

    if count >= 6
      return false
    else
      return true
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

    ProposalNotification.create(title: 'a', body: 'Eliminamos tu sugerencia: "Hola"', author_id: 1, proposal_id: 1)

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
