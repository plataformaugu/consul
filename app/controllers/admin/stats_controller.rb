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
          @quizzes = Quiz.where(group_id: nil).where.not(name: 'TMP').order(created_at: :asc)
          @filename += 'individual.csv'
          csv << [
            'Fecha de creación',
            '¿Cuáles de estos temas de derechos humanos son para tí los tres más importantes?',
            '¿En cuál de estos temas crees que se respetan menos los derechos humanos de las personas?',
            'En aquel tema en que se respetan menos los derechos humanos, ¿En qué notas que no se respetan?',
            '¿Cuál o cuáles crees que son las causas de ese problema?',
            '¿Qué efectos tiene en las personas?',
            '¿A quienes crees que afecta este problema?',
            '¿En qué lugares crees que se vive este problema?',
            'En tu opinión, ¿qué medidas o acciones deberían tomar las autoridades para solucionar el problema que identificaste?',
            '¿Cómo podrían los niños, niñas y adolescentes ayudar a monitorear que las autoridades cumplan con sus compromisos de derechos humanos?',
            '¿Te interesaría participar del monitoreo o seguimiento al Plan Nacional de Derechos Humanos?',
            '¿En qué comuna vives?',
            '¿Con cuál género te identificas?',
            '¿En qué país naciste?',
            '¿Cuántos años tienes?',
            '¿Tienes algún tipo de discapacidad?',
            '¿Perteneces a algún pueblo indígena o tribal?',
            '¿Dónde vives actualmente?',
            '¿Cuál es tu orientación sexual?',
            '¿Es público?',
            '¿Está oculto?',
          ]
          @quizzes.each do |q|
            csv << [
              q.created_at.strftime('%Y-%m-%d'),
              q.q1.nil? ? '' : (eval(q.q1).fetch('q1', '').is_a?(Array) ? eval(q.q1)['q1'].join(', ') : ''),
              q.q1.nil? ? '' : eval(q.q1).fetch('q2', ''),
              q.q1.nil? ? '' : eval(q.q1).fetch('q3', ''),
              q.q1.nil? ? '' : eval(q.q1).fetch('q4', ''),
              q.q1.nil? ? '' : eval(q.q1).fetch('q5', ''),
              q.q1.nil? ? '' : (eval(q.q1).fetch('q6', '').is_a?(Array) ? eval(q.q1)['q6'].join(', ') : ''),
              q.q1.nil? ? '' : (eval(q.q1).fetch('q7', '').is_a?(Array) ? eval(q.q1)['q7'].join(', ') : ''),
              q.q2.nil? ? '' : eval(q.q2).fetch('q8', ''),
              q.q3.nil? ? '' : eval(q.q3).fetch('q9', ''),
              q.q3.nil? ? '' : eval(q.q3).fetch('q10', ''),
              q.q4.nil? ? '' : eval(q.q4).fetch('q11', ''),
              q.q4.nil? ? '' : eval(q.q4).fetch('q12', ''),
              q.q4.nil? ? '' : eval(q.q4).fetch('q13', ''),
              q.q4.nil? ? '' : eval(q.q4).fetch('q14', ''),
              q.q4.nil? ? '' : eval(q.q4).fetch('q15', ''),
              q.q4.nil? ? '' : eval(q.q4).fetch('q16', ''),
              q.q4.nil? ? '' : eval(q.q4).fetch('q17', ''),
              q.q4.nil? ? '' : eval(q.q4).fetch('q18', ''),
              q.visible ? 'Si' : 'No',
              q.is_active ? 'No' : 'Si',
            ]
          end
        elsif @type == 2
          @quizzes = Quiz.where.not(group_id: nil).where.not(name: 'TMP').order(created_at: :asc)
          @filename += 'grupal.csv'
          csv << [
            'Fecha de creación',
            'Participantes',
            '¿En cuál de estos temas creen que se respetan menos los derechos humanos de las personas?',
            'A continuación, seleccionen el tema que escogió el grupo como aquel en que menos se respetan los derechos humanos',
            'En aquel tema en que se respetan menos los derechos humanos, ¿En qué nota el grupo que no se respetan y qué problema identifican?',
            '¿Cuál o cuáles creen que son las causas de ese problema?',
            '¿Qué efectos tiene en las personas?',
            '¿A quienes creen que afecta este problema?',
            '¿En qué lugares crees que se vive este problema?',
            'En opinión del grupo, ¿qué medidas o acciones deberían tomar las autoridades para solucionar el problema que identificaron?',
            '¿Cómo podrían los niños, niñas y adolescentes ayudar a monitorear que las autoridades cumplan con sus compromisos de derechos humanos?',
            '¿Les interesaría participar del monitoreo o seguimiento al Plan Nacional de Derechos Humanos?',
            '¿Qué tipo de grupo forman ustedes?',
            '¿Qué actividad o actividades definen mejor los intereses del grupo?',
            '¿En qué país nacieron?',
            '¿Hay algún miembro del grupo con algún tipo de discapacidad?',
            '¿A qué pueblo o pueblos indígenas o tribales pertenecen los miembros del grupo?',
            '¿Dónde viven los miembros del grupo actualmente?',
            '¿Qué edad tiene el o la participante más pequeño del grupo?',
            '¿Qué edad tiene el o la participante más grande del grupo?',
            '¿En qué comuna vive la mayoría de los miembros del grupo?',
            '¿Es público?',
            '¿Está oculto?',
          ]
          @quizzes.each do |q|
            csv << [
              q.created_at.strftime('%Y-%m-%d'),
              Group.find(q.group_id).users.map{|u| u[:name]}.join(', '),
              eval(q.q1).select{|k, h| k.starts_with? 'q1'}.transform_keys{|k| k.tr('q1_', '')}.map{|k, h| "#{k}: #{h}"}.join(', '),
              eval(q.q1).fetch('q2', ''),
              eval(q.q1).fetch('q3', ''),
              eval(q.q1).fetch('q4', ''),
              eval(q.q1).fetch('q5', ''),
              eval(q.q1).select{|k, h| k.starts_with? 'q6'}.transform_keys{|k| k.tr('q6_', '')}.map{|k, h| "#{k}: #{h}"}.join(', '),
              eval(q.q1).select{|k, h| k.starts_with? 'q7'}.transform_keys{|k| k.tr('q7_', '')}.map{|k, h| "#{k}: #{h}"}.join(', '),
              eval(q.q2).fetch('q8', ''),
              eval(q.q3).fetch('q9', ''),
              eval(q.q3).fetch('q10', ''),
              eval(q.q4).fetch('q11', ''),
              q.q4.nil? ? '' : (eval(q.q4).fetch('q12', '').is_a?(Array) ? eval(q.q4)['q12'].join(', ') : ''),
              eval(q.q4).select{|k, h| k.starts_with? 'q13'}.transform_keys{|k| k.tr('q13_', '')}.map{|k, h| "#{k.capitalize}: #{h}"}.join(', '),
              eval(q.q4).select{|k, h| k.starts_with? 'q14'}.transform_keys{|k| k.tr('q14_', '')}.map{|k, h| "#{k.capitalize}: #{h}"}.join(', '),
              eval(q.q4).fetch('q15', ''),
              eval(q.q4).select{|k, h| k.starts_with? 'q16'}.transform_keys{|k| k.tr('q16_', '')}.map{|k, h| "#{k.capitalize}: #{h}"}.join(', '),
              eval(q.q4).fetch('q17', ''),
              eval(q.q4).fetch('q18', ''),
              eval(q.q4).fetch('q19', ''),
              q.visible ? 'Si' : 'No',
              q.is_active ? 'No' : 'Si',
            ]
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
