class Admin::StatsController < Admin::BaseController
  before_action :set_tabs, only: [:show, :proposals, :polls, :surveys]

  PROCESS_PROPOSALS = 'proposals'
  PROCESS_POLLS = 'polls'
  PROCESS_SURVEYS = 'surveys'

  PROCESSES = [
    PROCESS_PROPOSALS,
    PROCESS_POLLS,
    PROCESS_SURVEYS,
  ]

  PROCESS_TRANSLATE = {
    PROCESS_PROPOSALS => 'Propuestas',
    PROCESS_POLLS => 'Consultas',
    PROCESS_SURVEYS => 'Encuestas',
  }

  def show
    @event_types = Ahoy::Event.distinct.order(:name).pluck(:name)
    @visits = Visit.count

    @users = User.all

    proposals_count = Proposal.count
    polls_count = ::Poll.count
    surveys_count = Survey.count

    @general = {
      proposals_count: proposals_count,
      polls_count: polls_count,
      surveys_count: surveys_count,
      total_count: (
        proposals_count +
        polls_count +
        surveys_count
      ),
    }
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

  def surveys
    all_records = Survey.order(:id)
    @records = apply_pagination(all_records, params)
    @answers = ActiveRecord::Base.connection.execute(
      "SELECT DISTINCT surveys.id, survey_item_answers.user_id " \
      "FROM surveys " \
      "INNER JOIN survey_items ON survey_items.survey_id = surveys.id " \
      "INNER JOIN survey_item_answers ON survey_item_answers.survey_item_id = survey_items.id;"
    ).count
  end

  def surveys_detail
    
  end

  def download_report
    csv = nil

    case params['format']
    when 'general'
      csv = generate_report_general
    when 'consultas'
      csv = generate_report_polls
    when 'propuestas'
      csv = generate_report_proposals
    when 'encuestas'
      csv = generate_report_surveys
    end

    if csv != nil
      send_data(
        csv,
        type: 'text/csv',
        filename: "reporte_#{params['format']}_#{Time.now.strftime('%Y%m%d_%H%M')}.csv"
      )
    end
  end

  def generate_report_surveys_detail
    survey_id = params['survey_id']
    survey = Survey.find(survey_id)

    answers_by_user = {}

    survey.items.each do |survey_item|
        survey_item.answers.each do |survey_item_answer|
            if answers_by_user[survey_item_answer.user_id].nil?
                answers_by_user[survey_item_answer.user_id] = {
                    'ID usuario' => survey_item_answer.user_id,
                    'Nombre usuario' => survey_item_answer.user.full_name.strip(),
                    'RUT usuario' => survey_item_answer.user.document_number.insert(-2, '-'),
                    survey_item.title => survey_item_answer.data
                }
            else
                answers_by_user[
                  survey_item_answer.user_id
                ][
                  survey_item.title
                ] = (
                  survey_item_answer.data.instance_of?(Array) ?
                  survey_item_answer.data.join(', ') :
                  survey_item_answer.data
                )
            end
        end
    end

    if answers_by_user.empty?
      redirect_to surveys_admin_stats_path, alert: 'La encuesta no tiene respuestas.'
      return
    end

    generated_csv = CSV.generate(headers: true, col_sep: ';', encoding: 'UTF-8') do |csv|
      csv << answers_by_user.values.first.keys

      answers_by_user.values.each do |record|
        csv << record.values
      end

      generated_csv = csv
    end

    send_data(
      generated_csv,
      type: 'text/csv',
      filename: "reporte_encuesta_#{params['survey_id']}_#{Time.now.strftime('%Y%m%d_%H%M')}.csv"
    )
  end

  private

    def voters_in_heading(heading)
      Vote.where(votable_type: "Budget::Investment").
      includes(:budget_investment).
      where(budget_investments: { heading_id: heading.id }).
      select("votes.voter_id").distinct.count
    end

    def set_tabs
      @tabs = [
        {label: 'General', action: 'show', path: admin_stats_path},
        {label: 'Consultas', action: 'polls', path: polls_admin_stats_path},
        {label: 'Propuestas', action: 'proposals', path: proposals_admin_stats_path},
        {label: 'Encuestas', action: 'surveys', path: surveys_admin_stats_path},
      ]
      @report_processes = [
        { key: PROCESS_PROPOSALS, label: PROCESS_TRANSLATE[PROCESS_PROPOSALS] },
        { key: PROCESS_POLLS, label: PROCESS_TRANSLATE[PROCESS_POLLS] },
        { key: PROCESS_SURVEYS, label: PROCESS_TRANSLATE[PROCESS_SURVEYS] },
      ]
    end

    def apply_pagination(records, params)
      paginated_records = Kaminari.paginate_array(records).page(params[:page]).per(12)

      return paginated_records
    end

    def get_report_participants_header_columns
      participants_component = Admin::Stats::ParticipantsComponent.new(nil)
      users_age_ranges = participants_component.instance_eval('users_ranges').map { |x| "Rango etario #{x[0]} - #{x[1]}"}

      header_columns = [
        'Género masculino',
        'Género femenino',
        'Género otros',
        *users_age_ranges,
      ]

      return header_columns
    end

    def get_report_participants_row_columns(users)
      participants_component = Admin::Stats::ParticipantsComponent.new(users)

      participants_by_age_ranges = participants_component.instance_eval('users_by_age_range')
      participants_by_age_ranges_row_columns = participants_by_age_ranges.map { |x| x[1][:count] }

      row_columns = [
        participants_component.instance_eval('users_male_count'),
        participants_component.instance_eval('users_female_count'),
        participants_component.instance_eval('users_other_gender_count'),
        *participants_by_age_ranges_row_columns,
      ]

      return row_columns
    end

    def generate_report_general
      polls_count = ::Poll.count
      proposals_count = Proposal.count
      surveys_count = Survey.count

      participants_header_columns = get_report_participants_header_columns
      participants_row_columns = get_report_participants_row_columns(User.all)
  
      header_columns = [
        'Procesos realizados',
        'Usuarios registrados',
        'Consultas',
        'Propuestas',
        'Encuestas',
        *participants_header_columns,
      ]
  
      row_columns = [
        (
          polls_count +
          proposals_count +
          surveys_count
        ),
        User.count,
        polls_count,
        proposals_count,
        surveys_count,
        *participants_row_columns,
      ]
  
      CSV.generate(headers: true, col_sep: ';', encoding: 'UTF-8') do |csv|
        csv << header_columns
        csv << row_columns
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

        ::Poll.order(:id).each do |record|
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

    def generate_report_surveys
      participants_header_columns = get_report_participants_header_columns

      header_columns = [
        'ID',
        'Nombre',
        'Participantes',
        *participants_header_columns,
      ]

      CSV.generate(headers: true, col_sep: ';', encoding: 'UTF-8') do |csv|
        csv << header_columns

        Survey.order(:id).each do |record|
          answers_users_ids = ActiveRecord::Base.connection.execute(
            "SELECT DISTINCT survey_item_answers.user_id " \
            "FROM surveys " \
            "INNER JOIN survey_items ON survey_items.survey_id = surveys.id " \
            "INNER JOIN survey_item_answers ON survey_item_answers.survey_item_id = survey_items.id " \
            "WHERE surveys.id = #{record.id}"
          ).to_a.map { |r| r['user_id'] }
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
end
