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
        caption: 'Cuenta Pública Participativa 2022 del Gore en Calama, ejercicio inédito impulsado por el Gobernador Ricardo Díaz y con alta participación de organizaciones sociales, además de autoridades.',
      },
      {
        image_url: '/images/home/slider/2.jpg',
        caption: 'Mesa del Agua realizada en Ayquina junto a dirigentes de diversas comunidades del Alto Loa, con el objetivo de abordar los desafíos que representa la escasez hídrica en la región.',
      },
      {
        image_url: '/images/home/slider/3.jpg',
        caption: 'Firma de compromiso del Plan “Unidos Por Bonilla”, con la presencia del Gobernador Regional, Ricardo Díaz, el subsecretario de Desarrollo Regional, Miguel Crispi, autoridades y organizaciones sociales.',
      },
      {
        image_url: '/images/home/slider/4.jpg',
        caption: 'Para el Gobierno Regional la inclusión es una prioridad, lo que ha motivado el apoyo a diversas iniciativas, entre ellas las impulsadas y ejecutadas por el Instituto Teletón.',
      },
      {
        image_url: '/images/home/slider/5.jpg',
        caption: 'Entrega de los Fondos del 7% de Interés Regional junto al Consejo Regional, recursos que permiten financiar diversas iniciativas presentadas por organizaciones sociales de la región. ',
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
        path: debate_path(@debate.id)
      })
    end
    
    if @proposal.present?
      @cards_elements.push({
        title: @proposal.title,
        summary: nil,
        description: ActionView::Base.full_sanitizer.sanitize(@proposal.description).truncate_words(24),
        image: @proposal.image.present? ? @proposal.image.variant(:medium) : '/images/process/proposals.svg',
        supertitle: 'Propuesta Ciudadana',
        path: "#{url_for(proposal_topics_path)}?proposal=#{@proposal.id}#card-#{@proposal.id}"
      })
    end

    if @poll.present?
      @cards_elements.push({
        title: @poll.title,
        summary: nil,
        description: ActionView::Base.full_sanitizer.sanitize(@poll.description).truncate_words(24),
        image: @poll.image.present? ? @poll.image.variant(:medium) : '/images/process/polls.svg',
        supertitle: 'Consulta',
        path: poll_path(@poll.id)
      })
    end

    if @budget.present?
      @cards_elements.push({
        title: @budget.name,
        summary: nil,
        description: ActionView::Base.full_sanitizer.sanitize(@budget.custom_description).truncate_words(24),
        image: @budget.image.present? ? @budget.image.variant(:medium) : '/images/process/budgets.svg',
        supertitle: 'Presupuesto Participativo',
        path: "#{url_for(budgets_path)}?budget=#{@budget.id}"
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
