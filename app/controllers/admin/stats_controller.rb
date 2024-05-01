class Admin::StatsController < Admin::BaseController
  before_action :set_tabs, only: [:show, :ppa, :prp, :proposals, :polls, :budgets]

  def show
    @event_types = Ahoy::Event.distinct.order(:name).pluck(:name)
    @visits = Visit.count

    @users = {
      count: User.active.count,
      males: User.male.count,
      females: User.female.count,
      other_genders: User.count - (User.male.count - User.female.count),
      by_age_range: get_users_by_age(User.all),
    }

    ppa_count = Debate.with_hidden.participatory_public_accounts.count
    prp_count = Debate.with_hidden.participatory_regulatory_plans.count
    proposals_count = Proposal.with_hidden.count
    polls_count = Poll.with_hidden.count
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
    all_records = Debate.with_hidden.participatory_public_accounts.order(:id)
    @records = apply_pagination(all_records, params)
    @votes = all_records.pluck(:cached_votes_up).sum
    @comments = all_records.pluck(:comments_count).sum
  end

  def ppa_detail
    @record = Debate.with_hidden.participatory_public_accounts.find(params[:id])

    comments_users_ids = Comment.where(commentable_type: "Debate", commentable_id: @record.id).pluck(:user_id)
    votes_users_ids = Vote.where(votable_type: "Debate", votable_id: @record.id).pluck(:voter_id)
    all_users_ids = (comments_users_ids + votes_users_ids).uniq
    all_users = User.where(id: all_users_ids)

    @users = {
      count: all_users.count,
      males: all_users.male.count,
      females: all_users.female.count,
      other_genders: all_users.count - (all_users.male.count - all_users.female.count),
      by_age_range: get_users_by_age(all_users),
    }
  end

  def prp
    all_records = Debate.with_hidden.participatory_regulatory_plans.order(:id)
    @records = apply_pagination(all_records, params)
    @votes = all_records.pluck(:cached_votes_up).sum
    @comments = all_records.pluck(:comments_count).sum
  end

  def prp_detail
    @record = Debate.with_hidden.participatory_regulatory_plans.find(params[:id])

    comments_users_ids = Comment.where(commentable_type: "Debate", commentable_id: @record.id).pluck(:user_id)
    votes_users_ids = Vote.where(votable_type: "Debate", votable_id: @record.id).pluck(:voter_id)
    all_users_ids = (comments_users_ids + votes_users_ids).uniq
    all_users = User.where(id: all_users_ids)

    @users = {
      count: all_users.count,
      males: all_users.male.count,
      females: all_users.female.count,
      other_genders: all_users.count - (all_users.male.count - all_users.female.count),
      by_age_range: get_users_by_age(all_users),
    }
  end

  def proposals
    all_records = Proposal.with_hidden.order(:id)
    @records = apply_pagination(all_records, params)
    @votes = Vote.where(votable_type: "Proposal").count
    @comments = Comment.where(commentable_type: "Proposal").count
  end

  def proposals_detail
    @record = Proposal.with_hidden.find(params[:id])

    comments_users_ids = Comment.where(commentable_type: "Proposal", commentable_id: @record.id).pluck(:user_id)
    votes_users_ids = Vote.where(votable_type: "Debate", votable_id: @record.id).pluck(:voter_id)
    all_users_ids = (comments_users_ids + votes_users_ids).uniq
    all_users = User.where(id: all_users_ids)

    @users = {
      count: all_users.count,
      males: all_users.male.count,
      females: all_users.female.count,
      other_genders: all_users.count - (all_users.male.count - all_users.female.count),
      by_age_range: get_users_by_age(all_users),
    }
  end

  def polls
    all_records = ::Poll.with_hidden.order(:id)
    @records = apply_pagination(all_records, params)
    @answers = ::Poll::Voter.count
  end

  def polls_detail
    @record = ::Poll.with_hidden.find(params[:id])

    answers_users_ids = @record.voters.pluck(:user_id)
    all_users_ids = answers_users_ids
    all_users = User.where(id: all_users_ids)

    @users = {
      count: all_users.count,
      males: all_users.male.count,
      females: all_users.female.count,
      other_genders: all_users.count - (all_users.male.count - all_users.female.count),
      by_age_range: get_users_by_age(all_users),
    }
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
    all_users = User.where(id: all_users_ids)

    @users = {
      count: all_users.count,
      males: all_users.male.count,
      females: all_users.female.count,
      other_genders: all_users.count - (all_users.male.count - all_users.female.count),
      by_age_range: get_users_by_age(all_users),
    }
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
        {label: 'Cuentas Públicas Participativas', action: 'ppa', path: ppa_admin_stats_path},
        {label: 'Planes Reguladores Participativos', action: 'prp', path: prp_admin_stats_path},
        {label: 'Consultas', action: 'polls', path: polls_admin_stats_path},
        {label: 'Propuestas', action: 'proposals', path: proposals_admin_stats_path},
        {label: 'Presupuestos Participativos', action: 'budgets', path: budgets_admin_stats_path},
      ]
    end

    def get_users_by_age(users)
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
        count = users.between_ages(start, finish).count
        range_description = I18n.t("stats.age_range", start: start, finish: finish)

        if finish > 200
          range_description = I18n.t("stats.age_more_than", start: start)
        end

        [
          "#{start} - #{finish}",
          {
            range: range_description,
            count: count,
            percentage: PercentageCalculator.calculate(count, users.count)
          }
        ]
      end
    end
end
