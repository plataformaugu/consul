class ProposalTopicsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_proposal_topic, only: [:show]

  load_and_authorize_resource

  def index
    @proposal_topics = Kaminari.paginate_array(ProposalTopic.published.order(created_at: :desc)).page(params[:page]).per(9)
  end

  def show
  end

  private
    def set_proposal_topic
      @proposal_topic = ProposalTopic.find(params[:id])
    end
end
