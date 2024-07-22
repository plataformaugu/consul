class Admin::StatsController < Admin::BaseController
  before_action :set_tabs, only: [:show, :ppa, :prp, :proposals, :polls, :budgets]

  PROCESS_PPA = 'ppa'
  PROCESS_PRP = 'prp'
  PROCESS_PROPOSALS = 'proposals'
  PROCESS_POLLS = 'polls'
  PROCESS_BUDGETS = 'budgets'

  PROCESSES = [
    PROCESS_PPA,
    PROCESS_PRP,
    PROCESS_PROPOSALS,
    PROCESS_POLLS,
    PROCESS_BUDGETS,
  ]

  PROCESS_TRANSLATE = {
    PROCESS_PPA => 'Cuentas Públicas',
    PROCESS_PRP => 'Planes Reguladores',
    PROCESS_PROPOSALS => 'Propuestas',
    PROCESS_POLLS => 'Consultas',
    PROCESS_BUDGETS =>'Presupuestos Participativos',
  }

  def show
    @event_types = Ahoy::Event.distinct.order(:name).pluck(:name)
    @visits = Visit.count

    @users = User.all

    ppa_count = Debate.participatory_public_accounts.count
    prp_count = Debate.participatory_regulatory_plans.count
    proposals_count = Proposal.count
    polls_count = Poll.count
    budgets_count = Budget.count

    @general = {
      ppa_count: ppa_count,
      prp_count: prp_count,
      proposals_count: proposals_count,
      polls_count: polls_count,
      budgets_count: budgets_count,
      total_count: (
        ppa_count +
        prp_count +
        proposals_count +
        polls_count +
        budgets_count
      ),
    }
  end

  def ppa
    all_records = Debate.participatory_public_accounts.order(:id)
    @records = apply_pagination(all_records, params)
    @votes = all_records.pluck(:cached_votes_up).sum
    @comments = all_records.pluck(:comments_count).sum
  end

  def ppa_detail
    @record = Debate.participatory_public_accounts.find(params[:id])

    comments_users_ids = Comment.where(commentable_type: "Debate", commentable_id: @record.id).pluck(:user_id)
    votes_users_ids = Vote.where(votable_type: "Debate", votable_id: @record.id).pluck(:voter_id)
    all_users_ids = (comments_users_ids + votes_users_ids).uniq
    @users = User.where(id: all_users_ids)
  end

  def prp
    all_records = Debate.participatory_regulatory_plans.order(:id)
    @records = apply_pagination(all_records, params)
    @votes = all_records.pluck(:cached_votes_up).sum
    @comments = all_records.pluck(:comments_count).sum
  end

  def prp_detail
    @record = Debate.participatory_regulatory_plans.find(params[:id])

    comments_users_ids = Comment.where(commentable_type: "Debate", commentable_id: @record.id).pluck(:user_id)
    votes_users_ids = Vote.where(votable_type: "Debate", votable_id: @record.id).pluck(:voter_id)
    all_users_ids = (comments_users_ids + votes_users_ids).uniq
    @users = User.where(id: all_users_ids)
  end

  def proposals
    all_records = Proposal.order(:id)
    @records = apply_pagination(all_records, params)
    @votes = Vote.where(votable_type: "Proposal").count
    @comments = Comment.where(commentable_type: "Proposal").count
  end

  def proposals_detail
    @record = Proposal.find(params[:id])

    comments_users_ids = Comment.where(commentable_type: "Proposal", commentable_id: @record.id).pluck(:user_id)
    votes_users_ids = Vote.where(votable_type: "Proposal", votable_id: @record.id).pluck(:voter_id)
    all_users_ids = (comments_users_ids + votes_users_ids).uniq
    @users = User.where(id: all_users_ids)
  end

  def polls
    all_records = ::Poll.order(:id)
    @records = apply_pagination(all_records, params)
    @answers = ::Poll::Voter.count
  end

  def polls_detail
    @record = ::Poll.find(params[:id])

    answers_users_ids = @record.voters.pluck(:user_id)
    all_users_ids = answers_users_ids
    @users = User.where(id: all_users_ids)
  end

  def budgets
    all_records = Budget.all.order(:id)
    @records = apply_pagination(all_records, params)
    @investments = Budget::Investment.where(budget_id: all_records.pluck(:id)).count
  end

  def budgets_detail
    @record = Budget.find(params[:id])

    investments_ids = @record.investments.pluck(:id)
    investments_users_ids = @record.investments.pluck(:author_id)

    @comments = Comment.where(
      commentable_type: "Budget::Investment",
      commentable_id: investments_ids,
    )
    comments_users_ids = @comments.pluck(:user_id)

    @votes = Vote.where(
      votable_type: "Budget::Investment",
      votable_id: investments_ids,
    )
    votes_users_ids = @votes.pluck(:voter_id)

    all_users_ids = (investments_users_ids + comments_users_ids + votes_users_ids).uniq
    @users = User.where(id: all_users_ids)
  end

  def download_report
    csv = nil

    case params['format']
    when 'general'
      csv = generate_report_general
    when 'cuentas_publicas_participativas'
      csv = generate_report_ppa
    when 'planes_reguladores_participativos'
      csv = generate_report_prp
    when 'consultas'
      csv = generate_report_polls
    when 'propuestas'
      csv = generate_report_proposals
    when 'presupuestos_participativos'
      csv = generate_report_budgets
    end

    if csv != nil
      send_data(
        csv,
        type: 'text/csv',
        filename: "reporte_#{params['format']}_#{Time.now.strftime('%Y%m%d_%H%M')}.csv"
      )
    end
  end

  private

    def voters_in_heading(heading)
      Vote.where(votable_type: "Budget::Investment").
      includes(:budget_investment).
      where(budget_investments: { heading_id: heading.id }).
      select("votes.voter_id").distinct.count
    end

    def apply_pagination(records, params)
      paginated_records = Kaminari.paginate_array(records).page(params[:page]).per(12)

      return paginated_records
    end

    def set_tabs
      @tabs = [
        {label: 'General', action: 'show', path: admin_stats_path},
        {label: 'Cuentas Públicas', action: 'ppa', path: ppa_admin_stats_path},
        {label: 'Planes Reguladores', action: 'prp', path: prp_admin_stats_path},
        {label: 'Consultas', action: 'polls', path: polls_admin_stats_path},
        {label: 'Propuestas', action: 'proposals', path: proposals_admin_stats_path},
        {label: 'Presupuestos Participativos', action: 'budgets', path: budgets_admin_stats_path},
      ]
      @report_processes = [
        { key: PROCESS_PPA, label: PROCESS_TRANSLATE[PROCESS_PPA] },
        { key: PROCESS_PRP, label: PROCESS_TRANSLATE[PROCESS_PPA] },
        { key: PROCESS_PROPOSALS, label: PROCESS_TRANSLATE[PROCESS_PROPOSALS] },
        { key: PROCESS_POLLS, label: PROCESS_TRANSLATE[PROCESS_POLLS] },
        { key: PROCESS_BUDGETS, label: PROCESS_TRANSLATE[PROCESS_BUDGETS] },
      ]
    end

    def get_report_participants_header_columns
      participants_component = Admin::Stats::ParticipantsComponent.new(nil)
      users_age_ranges = participants_component.instance_eval('users_ranges').map { |x| "Rango etario #{x[0]} - #{x[1]}"}
      users_sectors = Sector.order(:internal_id).pluck(:name).map { |x| "Sector #{x}"}

      header_columns = [
        'Género masculino',
        'Género femenino',
        'Género otros',
        *users_age_ranges,
        *users_sectors,
      ]

      return header_columns
    end

    def get_report_participants_row_columns(users)
      participants_component = Admin::Stats::ParticipantsComponent.new(users)

      participants_by_age_ranges = participants_component.instance_eval('users_by_age_range')
      participants_by_age_ranges_row_columns = participants_by_age_ranges.map { |x| x[1][:count] }

      base_participants_by_sector = Sector.pluck(:name).map { |x| [x, 0] }.to_h
      participants_by_sector = users.all.where.not(sector_id: nil).includes(:sector).pluck(:name).tally

      participants_by_sector.each do |sector_name, count|
        base_participants_by_sector[sector_name] = count
      end

      row_columns = [
        participants_component.instance_eval('users_male_count'),
        participants_component.instance_eval('users_female_count'),
        participants_component.instance_eval('users_other_gender_count'),
        *participants_by_age_ranges_row_columns,
        *base_participants_by_sector.values,
      ]

      return row_columns
    end

    def generate_report_general
      ppa_count = Debate.participatory_public_accounts.count
      prp_count = Debate.participatory_regulatory_plans.count
      polls_count = Poll.count
      proposals_count = Proposal.count
      budgets_count = Budget.count

      participants_header_columns = get_report_participants_header_columns
      participants_row_columns = get_report_participants_row_columns(User.all)
  
      header_columns = [
        'Procesos realizados',
        'Usuarios registrados',
        'Cuentas Públicas',
        'Planes Reguladores',
        'Consultas',
        'Propuestas',
        'Presupuestos Participativos',
        *participants_header_columns,
      ]
  
      row_columns = [
        (
          ppa_count +
          prp_count +
          proposals_count +
          polls_count +
          budgets_count
        ),
        User.count,
        ppa_count,
        prp_count,
        polls_count,
        proposals_count,
        budgets_count,
        *participants_row_columns,
      ]
  
      CSV.generate(headers: true, col_sep: ';', encoding: 'UTF-8') do |csv|
        csv << header_columns
        csv << row_columns
      end
    end

    def generate_report_ppa
      participants_header_columns = get_report_participants_header_columns

      header_columns = [
        'ID',
        'Nombre',
        'Participantes',
        'Votos positivos',
        'Votos negativos',
        'Comentarios',
        *participants_header_columns,
      ]

      CSV.generate(headers: true, col_sep: ';', encoding: 'UTF-8') do |csv|
        csv << header_columns

        Debate.participatory_public_accounts.order(:id).each do |record|
          comments_users_ids = Comment.where(commentable_type: "Debate", commentable_id: record.id).pluck(:user_id)
          votes_users_ids = Vote.where(votable_type: "Debate", votable_id: record.id).pluck(:voter_id)
          all_users_ids = (comments_users_ids + votes_users_ids).uniq
          users = User.where(id: all_users_ids)
          participants_row_columns = get_report_participants_row_columns(users)

          csv << [
            record.id,
            record.title,
            users.count,
            record.cached_votes_up,
            record.cached_votes_down,
            record.comments_count,
            *participants_row_columns,
          ]
        end
      end
    end

    def generate_report_prp
      participants_header_columns = get_report_participants_header_columns

      header_columns = [
        'ID',
        'Nombre',
        'Participantes',
        'Votos positivos',
        'Votos negativos',
        'Comentarios',
        *participants_header_columns,
      ]

      CSV.generate(headers: true, col_sep: ';', encoding: 'UTF-8') do |csv|
        csv << header_columns

        Debate.participatory_regulatory_plans.order(:id).each do |record|
          comments_users_ids = Comment.where(commentable_type: "Debate", commentable_id: record.id).pluck(:user_id)
          votes_users_ids = Vote.where(votable_type: "Debate", votable_id: record.id).pluck(:voter_id)
          all_users_ids = (comments_users_ids + votes_users_ids).uniq
          users = User.where(id: all_users_ids)
          participants_row_columns = get_report_participants_row_columns(users)

          csv << [
            record.id,
            record.title,
            users.count,
            record.cached_votes_up,
            record.cached_votes_down,
            record.comments_count,
            *participants_row_columns,
          ]
        end
      end
    end

    def generate_report_polls
      participants_header_columns = get_report_participants_header_columns

      header_columns = [
        'ID',
        'Nombre',
        'Participantes',
        *participants_header_columns,
      ]

      CSV.generate(headers: true, col_sep: ';', encoding: 'UTF-8') do |csv|
        csv << header_columns

        Poll.order(:id).each do |record|
          answers_users_ids = record.voters.pluck(:user_id)
          all_users_ids = answers_users_ids.uniq
          users = User.where(id: all_users_ids)
          participants_row_columns = get_report_participants_row_columns(users)

          csv << [
            record.id,
            record.title,
            users.count,
            *participants_row_columns,
          ]
        end
      end
    end

    def generate_report_proposals
      participants_header_columns = get_report_participants_header_columns

      header_columns = [
        'ID',
        'Nombre',
        'Participantes',
        'Apoyos',
        'Comentarios',
        *participants_header_columns,
      ]

      CSV.generate(headers: true, col_sep: ';', encoding: 'UTF-8') do |csv|
        csv << header_columns

        Proposal.order(:id).each do |record|
          comments_users_ids = Comment.where(commentable_type: "Proposal", commentable_id: record.id).pluck(:user_id)
          votes_users_ids = Vote.where(votable_type: "Proposal", votable_id: record.id).pluck(:voter_id)
          all_users_ids = (comments_users_ids + votes_users_ids).uniq
          users = User.where(id: all_users_ids)
          participants_row_columns = get_report_participants_row_columns(users)

          csv << [
            record.id,
            record.title,
            users.count,
            record.cached_votes_up,
            record.comments_count,
            *participants_row_columns,
          ]
        end
      end
    end

    def generate_report_budgets
      participants_header_columns = get_report_participants_header_columns

      header_columns = [
        'ID',
        'Nombre',
        'Participantes',
        'Proyectos',
        'Apoyos',
        'Comentarios',
        *participants_header_columns,
      ]

      CSV.generate(headers: true, col_sep: ';', encoding: 'UTF-8') do |csv|
        csv << header_columns

        Budget.order(:id).each do |record|
          investments_ids = record.investments.pluck(:id)
          investments_users_ids = record.investments.pluck(:author_id)
      
          comments = Comment.where(
            commentable_type: "Budget::Investment",
            commentable_id: investments_ids,
          )
          comments_users_ids = comments.pluck(:user_id)
      
          votes = Vote.where(
            votable_type: "Budget::Investment",
            votable_id: investments_ids,
          )
          votes_users_ids = votes.pluck(:voter_id)
      
          all_users_ids = (investments_users_ids + comments_users_ids + votes_users_ids).uniq
          users = User.where(id: all_users_ids)
          participants_row_columns = get_report_participants_row_columns(users)

          csv << [
            record.id,
            record.name,
            users.count,
            record.investments.count,
            votes.count,
            comments.count,
            *participants_row_columns,
          ]
        end
      end
    end
end
