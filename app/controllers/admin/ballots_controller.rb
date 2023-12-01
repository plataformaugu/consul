class Admin::BallotsController < Admin::BaseController
  before_action :set_ballot, only: [:show, :edit, :update, :destroy]

  NOTICE_TEXT = "La votación fue %{action} correctamente."

  def index
    @ballots = Ballot.all
  end

  def new
    @ballot = Ballot.new
  end

  def edit
  end

  def create
    @ballot = Ballot.new(ballot_params.merge(user: current_user, choices: ballot_params[:choices].split(',').map{ |value| value.strip }))

    if @ballot.save
      redirect_to admin_ballots_path, notice: NOTICE_TEXT % {action: 'creada'}
    else
      render :new
    end
  end

  def update
    if @ballot.update(ballot_params.merge(choices: ballot_params[:choices].split(',').map{ |value| value.strip }))
      @ballot.save

      redirect_to admin_ballots_path, notice: NOTICE_TEXT % {action: 'actualizada'}
    else
      render :edit
    end
  end

  def destroy
    @ballot.destroy
    redirect_to admin_ballots_path, notice: NOTICE_TEXT % {action: 'eliminada'}
  end

  private
    def set_ballot
      @ballot = Ballot.find(params[:id])
    end

    def ballot_params
      params.require(:ballot).permit(:title, :description, :ballot_type, :choices)
    end
end
