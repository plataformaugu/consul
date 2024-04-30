class Polls::QuestionsController < ApplicationController
  load_and_authorize_resource :poll
  load_and_authorize_resource :question, class: "Poll::Question"

  has_orders %w[most_voted newest oldest], only: :show

  def answer
    answer = @question.find_or_initialize_user_answer(current_user, params[:answer])
    answer.save_and_record_voter_participation

    if @question.poll.full_answered_by_user?(current_user)
      flash[:notice] = "¡Muchas gracias por participar! Tus respuestas han sido registradas correctamente."
      Activity.log(current_user, :answer, @question)
      redirect_to poll_path(@question.poll)
      return
    end

    respond_to do |format|
      format.html do
        redirect_to request.referer
      end
      format.js do
        render :answers
      end
    end
  end
end
