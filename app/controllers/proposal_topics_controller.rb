class ProposalTopicsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_proposal_topic, only: [:show]

  load_and_authorize_resource

  has_orders %w[most_voted newest oldest], only: :index

  def index
    param_proposal = params['proposal']
    param_proposal_topic = params['topic']

    @proposal_topics = ProposalTopic.published.order(created_at: :desc)
    @proposal_topic = @proposal_topics.first
    @proposals = []
    @proposal = nil

    if param_proposal.present?
      @proposal = Proposal.published.find_by(id: params['proposal'])

      if @proposal.present?
        @proposal_topic = @proposal.proposal_topic
        @proposals = @proposal_topic.proposals.published.order(created_at: :asc)
      end
    end

    if param_proposal_topic.present?
      if ProposalTopic.published.find_by(id: params['topic'])
        @proposal_topic = ProposalTopic.published.find_by(id: params['topic'])
        @proposals = @proposal_topic.proposals.published.order(created_at: :asc)
        @proposal = @proposals.first
      end
    end

    if !@proposals.any? && @proposal_topic.present?
      @proposals = @proposal_topic.proposals.published.order(created_at: :asc)
      @proposal = @proposals.first
    end

    if @proposals.any?
      @proposals = @proposals.where.not(id: @proposal.id).reverse.map { |p| {
        id: p.id,
        title: p.title,
        summary: nil,
        description: p.summary,
        image: p.image.present? ? p.image.variant(:large) : '/images/process/proposals.svg',
        supertitle: nil,
        path: "#{url_for(proposal_topics_path)}?proposal=#{p.id}#card-#{p.id}"
      } }
      @proposals.push(
        *[@proposal].map { |p| {
          id: p.id,
          title: p.title,
          summary: p.summary,
          description: p.description,
          image: p.image.present? ? p.image.variant(:large) : '/images/process/proposals.svg',
          supertitle: nil,
          path: "#{url_for(proposal_topics_path)}?proposal=#{p.id}#card-#{p.id}"
        } }
      )
    end

    if !@proposal.nil?
      @comment_tree = CommentTree.new(@proposal, params[:page], @current_order)
    end
  end

  def show
  end

  private
    def set_proposal_topic
      @proposal_topic = ProposalTopic.find(params[:id])
    end
end
