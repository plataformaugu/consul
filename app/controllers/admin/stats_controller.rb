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
    PROCESS_PPA => 'Cuentas Públicas Participativas',
    PROCESS_PRP => 'Cuentas Públicas Participativas',
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
    votes_users_ids = Vote.where(votable_type: "Debate", votable_id: @record.id).pluck(:voter_id)
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
    processes =  params['report_processes']

    columns = ['Proceso', 'Participantes', 'Participantes Masculinos', 'Participantes Femeninos']

    CSV.generate(headers: true) do |csv|
    end

    processes.each do |process|
      if PROCESSES.include?(process)
        raise
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
      @report_processes = [
        { key: PROCESS_PPA, label: PROCESS_TRANSLATE[PROCESS_PPA] },
        { key: PROCESS_PRP, label: PROCESS_TRANSLATE[PROCESS_PPA] },
        { key: PROCESS_PROPOSALS, label: PROCESS_TRANSLATE[PROCESS_PROPOSALS] },
        { key: PROCESS_POLLS, label: PROCESS_TRANSLATE[PROCESS_POLLS] },
        { key: PROCESS_BUDGETS, label: PROCESS_TRANSLATE[PROCESS_BUDGETS] },
      ]
    end
end
