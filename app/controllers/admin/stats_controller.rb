class Admin::StatsController < Admin::BaseController
  def show
    @event_types = Ahoy::Event.distinct.order(:name).pluck(:name)
    @visits = Visit.count

    # Participatory Public Accounts
    @participatory_public_accounts = {
      count: Debate.with_hidden.participatory_public_accounts.count,
      votes: Debate.with_hidden.participatory_public_accounts.pluck(:cached_votes_up).sum,
      comments: Debate.with_hidden.participatory_public_accounts.pluck(:comments_count).sum,
    }

    # Participatory Regulatory Plans
    @participatory_regulatory_plans = {
      count: Debate.with_hidden.participatory_regulatory_plans.count,
      votes: Debate.with_hidden.participatory_regulatory_plans.pluck(:cached_votes_up).sum,
      comments: Debate.with_hidden.participatory_regulatory_plans.pluck(:comments_count).sum,
    }

    # Proposals
    @proposals = {
      count: Proposal.with_hidden.count,
      votes: Vote.where(votable_type: "Proposal").count,
      comments: Comment.where(commentable_type: "Proposal").count,
    }

    # Polls
    @polls = {
      count: Poll.with_hidden.count,
      answers: Poll::Voter.count,
    }

    # Budgets
    budgets_ids = Budget.where.not(phase: "finished").ids
    @budgets = {
      count: budgets_ids.size,
      investments: Budget::Investment.where(budget_id: budgets_ids).count,
    }

    # Users
    @users = {
      count: User.active.count,
      males: User.male.count,
      females: User.female.count,
      other_genders: User.count - (User.male.count - User.female.count),
      by_age_range: get_users_by_age,
    }

    # General
    @general = {
      total_count: (
        @participatory_public_accounts[:count] +
        @participatory_regulatory_plans[:count] +
        @proposals[:count] +
        @polls[:count] +
        @budgets[:count]
      ),
    }
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

  private

    def voters_in_heading(heading)
      Vote.where(votable_type: "Budget::Investment").
      includes(:budget_investment).
      where(budget_investments: { heading_id: heading.id }).
      select("votes.voter_id").distinct.count
    end

    def get_users_by_age
      [[16, 19],
       [20, 24],
       [25, 29],
       [30, 34],
       [35, 39],
       [40, 44],
       [45, 49],
       [50, 54],
       [55, 59],
       [60, 64],
       [65, 69],
       [70, 74],
       [75, 79],
       [80, 84],
       [85, 89],
       [90, 300]
      ].to_h do |start, finish|
        count = User.between_ages(start, finish).count
        range_description = I18n.t("stats.age_range", start: start, finish: finish)

        if finish > 200
          range_description = I18n.t("stats.age_more_than", start: start)
        end

        [
          "#{start} - #{finish}",
          {
            range: range_description,
            count: count,
            percentage: PercentageCalculator.calculate(count, User.count)
          }
        ]
      end
    end
end
