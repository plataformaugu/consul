class WelcomeController < ApplicationController
  include RemotelyTranslatable

  skip_authorization_check
  before_action :set_user_recommendations, only: :index, if: :current_user
  before_action :authenticate_user!, only: :welcome

  layout "devise", only: :welcome

  def index
    @slider_elements = [
      {
        image_url: '/images/home/slider/1.jpg',
        caption: 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutLorem ipsum dolor sit amet, consectetuer adipis',
      },
      {
        image_url: '/images/home/slider/2.jpg',
        caption: 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutLorem ipsum dolor sit amet, consectetuer adipis',
      },
      {
        image_url: '/images/home/slider/3.jpg',
        caption: 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutLorem ipsum dolor sit amet, consectetuer adipis',
      },
      {
        image_url: '/images/home/slider/4.jpg',
        caption: 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutLorem ipsum dolor sit amet, consectetuer adipis',
      },
      {
        image_url: '/images/home/slider/5.jpg',
        caption: 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutLorem ipsum dolor sit amet, consectetuer adipis',
      },
    ]

    # Destacados
    @debate = Debate.published.order(created_at: :desc).first
    @proposal = Proposal.published.order(created_at: :desc).first
    @poll = Poll.created_by_admin.order(created_at: :desc).first
    @budget = Budget.published.order(created_at: :desc).first

    @cards_elements = []

    if @debate.present?
      @cards_elements.push({
        title: @debate.title,
        summary: nil,
        description: ActionView::Base.full_sanitizer.sanitize(@debate.description).truncate_words(24),
        image: @debate.image.present? ? @debate.image : '/images/process/debates.svg',
        supertitle: 'Debate',
      })
    end
    
    if @proposal.present?
      @cards_elements.push({
        title: @proposal.title,
        summary: nil,
        description: ActionView::Base.full_sanitizer.sanitize(@proposal.description).truncate_words(24),
        image: @proposal.image.present? ? @proposal.image.variant(:medium) : '/images/process/proposals.svg',
        supertitle: 'Propuesta Ciudadana',
      })
    end

    if @poll.present?
      @cards_elements.push({
        title: @poll.title,
        summary: nil,
        description: ActionView::Base.full_sanitizer.sanitize(@poll.description).truncate_words(24),
        image: @poll.image.present? ? @poll.image.variant(:medium) : '/images/process/polls.svg',
        supertitle: 'Consulta',
      })
    end

    if @budget.present?
      @cards_elements.push({
        title: @budget.name,
        summary: nil,
        description: ActionView::Base.full_sanitizer.sanitize(@budget.custom_description).truncate_words(24),
        image: @budget.image.present? ? @budget.image.variant(:medium) : '/images/process/budgets.svg',
        supertitle: 'Presupuesto Participativo',
      })
    end

    # Mapa
    @provinces_mapping = Province.all.map { |p| [p.name, {'communes': p.communes.map { |c| { 'id': c.id, 'name': c.name, 'image': c.image } }, 'description': p.description}]}.to_h
  end

  def welcome
    redirect_to root_path
  end

  private

    def set_user_recommendations
      @recommended_debates = Debate.recommendations(current_user).sort_by_recommendations.limit(3)
      @recommended_proposals = Proposal.recommendations(current_user).sort_by_recommendations.limit(3)
    end
end
