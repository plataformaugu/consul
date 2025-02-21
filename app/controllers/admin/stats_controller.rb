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
    budgets_ids = Budget.where.not(phase: "finished").ids
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

  def polls_2
    @surveys = Survey.where(survey_type: Survey::TYPE_POLL)
    survey_item_ids = Survey::Item.where(survey: @surveys).pluck(:id).uniq
    survey_items_answers = Survey::Item::Answer.all.where(survey_item_id: survey_item_ids)
    participant_ids = survey_items_answers.pluck(:user_id).uniq
    @participants = User.where(id: participant_ids)
  end

  def surveys
    @surveys = Survey.where(survey_type: Survey::TYPE_SURVEY)
    survey_item_ids = Survey::Item.where(survey: @surveys).pluck(:id).uniq
    survey_items_answers = Survey::Item::Answer.all.where(survey_item_id: survey_item_ids)
    participant_ids = survey_items_answers.pluck(:user_id).uniq
    @participants = User.where(id: participant_ids)
  end

  def sdg
    @goals = SDG::Goal.order(:code)
  end

  def generate_report
    csv = nil
    case params['format']
    when 'proposals'
      csv = report_proposals
    when 'polls'
      csv = report_polls
    when 'events'
      csv = report_events
    when 'polls_2'
      csv = report_polls_2
    when 'surveys'
      csv = report_surveys
    end

    if csv != nil
      send_data(csv, type: 'text/csv', filename: "#{params['format']}_#{Time.now.strftime('%Y%m%d_%H%M')}.csv")
    end
  end

  def report_proposals
    excluded_words = [
      'donde',
      'porque',
      'porqué',
      'cuando',
      'están',
      'desde',
      'dónde',
      'fueron',
      'fuesen',
      'sobre',
      'altas',
      'altos',
      'bajos',
      'bajas',
    ]

    CSV.generate(headers: true, col_sep: ';') do |csv|
      csv << [
        'ID',
        'Título',
        'Comentarios',
        'Votos',
        'Usuario',
        'Palabra clave'
      ]

      Proposal.order(:id).each do |p|
        most_repeated_word = nil
        words = Rails::Html::FullSanitizer.new.sanitize(p.description).split(' ').map{|w| w.downcase }.filter{|w| w.length > 4 and not excluded_words.include?(w)}.map{|w| w.downcase }.tally.sort_by(&:last).reverse.to_h
        if words.any?
            most_repeated_word = words.keys[0]
        end

        csv << [
          p.id,
          p.title,
          p.comments.count,
          p.total_votes,
          p.author_id,
          most_repeated_word
        ]
      end
    end
  end

  def report_polls
    CSV.generate(headers: true, col_sep: ';') do |csv|
      csv << [
        'ID', 
        'Título', 
        'Comentarios', 
        'Pregunta', 
        'Respuesta', 
        'Votos'
      ]

      Poll::Question::Answer.all.joins(:question).order('poll_questions.poll_id ASC').each do |p|
        csv << [
          p.question.poll_id,
          p.question.poll.title,
          p.question.poll.comments.count,
          p.question.title,
          p.title,
          p.total_votes
        ]
      end

      csv = csv.sort_by { |csv| csv[0] }
    end
  end

  def report_polls_2
    report_surveys_common(Survey::TYPE_POLL)
  end

  def report_surveys
    report_surveys_common(Survey::TYPE_SURVEY)
  end

  def report_events
    CSV.generate(headers: true, col_sep: ';') do |csv|
      csv << [
        'ID', 
        'Título', 
        'Fecha de inicio', 
        'Fecha de término', 
        'Participantes', 
      ]

      Event.all.each do |e|
        csv << [
          e.id,
          e.title,
          e.start_time.strftime('%d-%m-%Y %H:%M'),
          e.end_time.strftime('%d-%m-%Y %H:%M'),
          e.users.count
        ]
      end
    end
  end

  private

    def voters_in_heading(heading)
      Vote.where(votable_type: "Budget::Investment").
      includes(:budget_investment).
      where(budget_investments: { heading_id: heading.id }).
      select("votes.voter_id").distinct.count
    end

    def report_surveys_common(type)
      CSV.generate(headers: true, col_sep: ';') do |csv|
        csv << [
          'ID', 
          'Título', 
          'Comentarios', 
          'Pregunta', 
          'Respuesta', 
          'Votos'
        ]

        Survey.where(survey_type: type).each do |survey|
          survey.items.each do |survey_item|
            csv << [
              survey.id,
              survey.title,
              survey.comments.count,
              survey_item.title,
              survey_item.answers.where.not("data::text = ''").pluck(:data).filter { |record| record != '' }.join(', '),
              survey.voters.count
            ]
          end
        end
  
        csv = csv.sort_by { |csv| csv[0] }
      end
    end
end
