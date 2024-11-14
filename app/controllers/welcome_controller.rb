class WelcomeController < ApplicationController
  include RemotelyTranslatable

  skip_authorization_check
  before_action :set_user_recommendations, only: :index, if: :current_user
  before_action :authenticate_user!, only: :welcome

  layout "devise", only: :welcome

  def index
    @slider_elements = [
      {
        image_url: '/images/home/slider/1.jpeg',
        caption: 'Primera sesión extraordinaria del Cosoc Regional del año 2023, encuentro que se desarrolló con el objetivo de capacitar a los integrantes del órgano consultivo en materias de inversión y presupuesto FNDR.',
        url: nil,
      },
      {
        image_url: '/images/home/slider/2.png',
        caption: 'El Ministerio de las Culturas, las Artes y el Patrimonio en colaboración con el Gobierno Regional de Antofagasta, invita a la comunidad a participar de la consulta sobre el uso de la Ex Molinera.',
        url: nil,
      },
      {
        image_url: '/images/home/slider/3.jpg',
        caption: 'Se entregaron los depósitos transitorios para las colecciones del Museo Regional de Antofagasta en dependencias de la ex Molinera.',
        url: nil,
      },
      {
        image_url: '/images/home/slider/4.jpg',
        caption: 'Este martes 12 de noviembre se realizó una sesión extraordinaria del Cosoc Regional con el objeto de capacitarlos acerca del Acuerdo de Escazú como también revisar el reglamento actual del organismo.',
        url: 'https://goreantofagasta.cl/el-cosoc-regional-recibio-capacitacion-sobre-el-acuerdo-de-escazu-y/goreantofagasta/2024-11-14/132908.html',
      },
      {
        image_url: '/images/home/slider/5.jpg',
        caption: 'El gobernador regional, Ricardo Díaz, estuvo presente junto a autoridades regionales, Fuerzas Armada y la comunidad en general, en la conmemoración del “Día Nacional de la Cantinera”',
        url: nil,
      },
    ]

    # Destacados
    @debate = Debate.published.order(created_at: :desc).first
    @proposal = Proposal.published.order(created_at: :desc).first
    @poll = Poll.current.created_by_admin.order(created_at: :desc).first
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
