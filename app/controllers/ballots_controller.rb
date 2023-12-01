class BallotsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  before_action :set_ballot, only: [:show, :edit, :update, :destroy, :answer]
  load_and_authorize_resource

  # GET /ballots
  def index
    @ballots = Kaminari.paginate_array(Ballot.all).page(params[:page])
  end

  # GET /ballots/1
  def show
  end

  def answer
    case @ballot.ballot_type
    when Ballot::BALLOT_UNIQUE
      BallotAnswer.create(ballot: @ballot, user: current_user, answer: [params['answer']])
    when Ballot::BALLOT_MULTIPLE
      BallotAnswer.create(ballot: @ballot, user: current_user, answer: params['answer'])
    when Ballot::BALLOT_PRIORIZATION
      BallotAnswer.create(ballot: @ballot, user: current_user, answer: params['answer'].split(','))
    when Ballot::BALLOT_OPEN_ANSWER
      BallotAnswer.create(ballot: @ballot, user: current_user, answer: [params['answer']])
    end

    redirect_to @ballot, notice: 'Tu respuesta fue registrada.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ballot
      @ballot = Ballot.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def ballot_params
      params.require(:ballot).permit(:title, :description, :ballot_type, :choices)
    end
end
