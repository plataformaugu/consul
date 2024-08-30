class PollsController < ApplicationController
  include FeatureFlags

  feature_flag :polls

  before_action :load_poll, except: [:index]
  before_action :load_active_poll, only: :index

  load_and_authorize_resource

  has_filters %w[current expired]
  has_orders %w[most_voted newest oldest], only: :show

  def index
    @polls = Kaminari.paginate_array(
      @polls.created_by_admin.not_budget.visible.includes(:geozones).order(created_at: :desc)
    ).page(params[:page])
  end

  def show
    if current_user.present? && !current_user.without_organization? && !@poll.organizations.include?(current_user.organization_name)
      redirect_to root_path, alert: "No tienes permiso para ver esta página"
    end

    @questions = @poll.questions.for_render.sort_for_list
    @comment_tree = CommentTree.new(@poll, params[:page], @current_order)
  end

  def stats
    @stats = Poll::Stats.new(@poll)
  end

  def results
    @stats = Poll::Stats.new(@poll)
    @total_votes = @poll.voters.count
  end

  def pending; end

  def answer
    prepared_answers = get_prepared_answers(@poll, params)

    if prepared_answers.nil?
      flash[:alert] = "Debes responder todas las preguntas."
      redirect_to poll_path(@poll)
      return
    end

    if params.has_key?(:manager_confirm)
      @prepared_answers = prepared_answers
      render :participate_manager_form
      return
    end

    if @poll.full_answered_by_user?(current_user)
      redirect_to poll_path(@poll), notice: "Ya respondiste esta consulta."
    end

    save_answers(prepared_answers, current_user)

    redirect_to poll_path(@poll), notice: "Las respuestas se registraron correctamente."
  end

  def participate_manager_form
  end

  def participate_manager_existing_user
    prepared_answers = JSON.parse(params[:prepared_answers])
    user_id = params[:user_id]

    if user_id.nil?
      flash[:error] = "Ocurrió un error inesperado. Vuelve a intentarlo."
      redirect_to poll_path(@poll.id)
      return
    end

    existing_user = User.find(user_id)

    if @poll.full_answered_by_user?(existing_user)
      flash[:error] = "Este usuario ya respondió la consulta."
      redirect_to poll_path(@poll.id)
      return
    end

    save_answers(prepared_answers, existing_user)

    flash[:notice] = "Se respondió la consulta en nombre de: #{existing_user.full_name}"
    redirect_to poll_path(@poll.id)
  end

  def participate_manager_new_user
    prepared_answers = JSON.parse(params[:user][:prepared_answers])
    clean_document_number = params[:user][:document_number].gsub(/[^a-z0-9]+/i, "").upcase

    if User.exists?(document_number: clean_document_number)
      flash[:error] = "Ya existe un usuario registrado con el RUT: #{clean_document_number}."
      redirect_to poll_path(@poll.id)
      return
    end

    if !params[:user][:email].empty? and User.exists?(email: params[:user][:email])
      flash[:error] = "Ya existe un usuario registrado con el email: #{params[:user][:email]}"
      redirect_to poll_path(@poll.id)
      return
    end

    permitted_params = params.require(:user).permit(
      :first_name,
      :last_name,
      :document_number,
      :email,
      :gender,
      :date_of_birth,
      :phone_number,
      :organization_name,
    ).merge(
      document_number: clean_document_number,
      email: params[:user][:email].empty? ? "manager_user_#{clean_document_number}@ugu.cl" : params[:user][:email],
      organization_name: params[:user].has_key?(:organization_name) ? params[:user][:organization_name] : current_user.organization_name
    )

    new_user = User.new(permitted_params)

    new_user.save(validate: false)

    save_answers(prepared_answers, new_user)

    flash[:notice] = "Se respondió la consulta en nombre de: #{new_user.full_name}"
    redirect_to poll_path(@poll.id)
  end

  private

    def load_poll
      @poll = Poll.find_by_slug_or_id!(params[:id])
    end

    def load_active_poll
      @active_poll = ActivePoll.first
    end

    def get_prepared_answers(poll, params)
      prepared_answers = []

      poll.questions.each do |poll_question|
        if !params[:poll].has_key?(poll_question.id.to_s)
          return nil
        end

        if !poll_question.question_answers.exists?(id: params[:poll][poll_question.id.to_s])
          return nil
        end

        poll_question_answer = poll_question.question_answers.find(params[:poll][poll_question.id.to_s])

        prepared_answers.push([poll_question.id, poll_question_answer.title])
      end

      return prepared_answers
    end

    def save_answers(prepared_answers, user)
      prepared_answers.each do |prepared_answer|
        poll_question = Poll::Question.find(prepared_answer[0])
        poll_question_answer = poll_question.answers.new(answer: prepared_answer[1], author: user)
        poll_question_answer.save_and_record_voter_participation
      end
    end
end
