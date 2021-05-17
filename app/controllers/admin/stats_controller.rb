class Admin::StatsController < Admin::BaseController
  def show
    @event_types = Ahoy::Event.distinct.order(:name).pluck(:name)

    @visits    = Visit.count
    @debates   = Debate.with_hidden.count
    @proposals = Proposal.with_hidden.count
    @comments  = Comment.not_valuations.with_hidden.count

    @debate_votes   = Vote.where(votable_type: "Debate").count
    @proposal_votes = Vote.where(votable_type: "Proposal").count
    @comment_votes  = Vote.where(votable_type: "Comment").count

    @votes = Vote.count

    @user_level_two   = User.active.level_two_verified.count
    @user_level_three = User.active.level_three_verified.count
    @verified_users   = User.active.level_two_or_three_verified.count
    @unverified_users = User.active.unverified.count
    @users = User.active.count

    @user_ids_who_voted_proposals = ActsAsVotable::Vote.where(votable_type: "Proposal")
                                                       .distinct
                                                       .count(:voter_id)

    @user_ids_who_didnt_vote_proposals = @verified_users - @user_ids_who_voted_proposals
    budgets_ids = Budget.where.not(phase: "finished").pluck(:id)
    @budgets = budgets_ids.size
    @investments = Budget::Investment.where(budget_id: budgets_ids).count
  end

  def graph
    @name = params[:id]
    @event = params[:event]

    if params[:event]
      @count = Ahoy::Event.where(name: params[:event]).count
    else
      @count = params[:count]
    end
  end

  def proposal_notifications
    @proposal_notifications = ProposalNotification.all
    @proposals_with_notifications = @proposal_notifications.select(:proposal_id).distinct.count
  end

  def direct_messages
    @direct_messages = DirectMessage.count
    @users_who_have_sent_message = DirectMessage.select(:sender_id).distinct.count
  end

  def budgets
    @budgets = Budget.all
  end

  def budget_supporting
    @budget = Budget.find(params[:budget_id])
    heading_ids = @budget.heading_ids

    votes = Vote.where(votable_type: "Budget::Investment").
            includes(:budget_investment).
            where(budget_investments: { heading_id: heading_ids })

    @vote_count = votes.count
    @user_count = votes.select(:voter_id).distinct.count

    @voters_in_heading = {}
    @budget.headings.each do |heading|
      @voters_in_heading[heading] = voters_in_heading(heading)
    end
  end

  def budget_balloting
    @budget = Budget.find(params[:budget_id])

    authorize! :read_admin_stats, @budget, message: t("admin.stats.budgets.no_data_before_balloting_phase")

    @user_count = @budget.ballots.select { |ballot| ballot.lines.any? }.count

    @vote_count = @budget.lines.count

    @vote_count_by_heading = @budget.lines.group(:heading_id).count.map { |k, v| [Budget::Heading.find(k).name, v] }.sort

    @user_count_by_district = User.where.not(balloted_heading_id: nil).group(:balloted_heading_id).count.map { |k, v| [Budget::Heading.find(k).name, v] }.sort
  end

  def polls
    @polls = ::Poll.current
    @participants = ::Poll::Voter.where(poll: @polls)
  end

  def sdg
    @goals = SDG::Goal.order(:code)
  end

  def generate_csv
    unless params['type'].present?
      redirect_to root_path
    else
      @type = params['type'].to_i
      csv = CSV.generate(:col_sep => ';') do |csv|
      @filename = DateTime.now.strftime('%Y-%m-%d_%H-%m-%S_')
        if @type == 1
          @quizzes = Quiz.where(quiz_type: 1)
          @filename += 'diagnosticos.csv'
          csv << [
            'Tema',
            'Titulo pregunta abierta',
            '¿De qué forma se manifiesta este desafío?',
            'Del siguiente listado, selecciona el que crees es el principal desafío de derechos humanos para este tema',
            '¿Cuál es el alcance geográfico de este desafío?',
            '¿A qué grupos de población afecta particularmente este desafío (selecciona todas las opciones que quieras)?',
            '¿Es público?',
            '¿Está oculto?',
            'Tipo de participación',
          ]
          @quizzes.each do |q|
            csv << [q.tag.name, q.name, q.description, q.q1, q.q3, q.q4, q.visible ? 'Si' : 'No', q.is_active ? 'No' : 'Si', q.user.is_individual? ? 'Individual' : 'Grupal']
          end
        elsif @type == 2
          @quizzes = Quiz.where(quiz_type: 2)
          @filename += 'monitoreos.csv'
          csv << [
            'Titulo pregunta abierta',
            'Ingresa una propuesta de iniciativa que creas deba ser comprometida por alguna institución pública en el Segundo PNDH',
            'Selecciona el área en la que quieres ingresar tu sugerencia para que la sociedad civil pueda dar seguimiento activo a la implementación del Segundo PNDH',
            'Ingrese la institución o tipo de instituciones que deben ser responsable de que su sugerencia se pueda realizar',
            '¿Es público?',
            '¿Está oculto?',
            'Tipo de participación',
          ]
          @quizzes.each do |q|
            csv << [q.name, q.description, q.q1, q.q3, q.visible ? 'Si' : 'No', q.is_active ? 'No' : 'Si', q.user.is_individual? ? 'Individual' : 'Grupal']
          end
        elsif @type == 3
          @quizzes = Quiz.where(quiz_type: 3)
          @filename += 'sugerencias.csv'
          csv << [
            'Tema',
            'Titulo pregunta abierta',
            'Ingresa una propuesta de iniciativa que creas deba ser comprometida por alguna institución pública en el Segundo PNDH',
            'Selecciona la institución pública que debería comprometerse a realizar la iniciativa que sugeriste',
            '¿Es público?',
            '¿Está oculto?',
            'Tipo de participación',
          ]
          @quizzes.each do |q|
            csv << [q.tag.name, q.name, q.description, q.q2, q.visible ? 'Si' : 'No', q.is_active ? 'No' : 'Si', q.user.is_individual? ? 'Individual' : 'Grupal']
          end
        end
      end
      send_data(csv, type: 'text/csv', filename: @filename)
    end
  end

  private

    def voters_in_heading(heading)
      Vote.where(votable_type: "Budget::Investment").
      includes(:budget_investment).
      where(budget_investments: { heading_id: heading.id }).
      select("votes.voter_id").distinct.count
    end
end
