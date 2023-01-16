module Abilities
  class Everyone
    include CanCan::Ability

    def initialize(user)
      can [:index, :show], News
      can [:show], Popup
      can [:index, :read], ProposalsTheme
      can [:read], Sector
      can [:read], Directive
      can [:read, :news], NeighborhoodCouncil
      can [:read], NeighborhoodCouncilEvent
      can :index, Encuestum
      can [:read, :map], Debate
      can [:read, :map, :summary, :share, :initiatives], Proposal
      can :login, User
      can :read, Comment
      can [:read, :results_index], Poll
      can :read, Event
      can [:functional_organizations_index, :functional_organizations, :read], MainTheme
      can [:read], FunctionalOrganization
      can :results, Poll, id: Poll.expired.results_enabled.not_budget.ids
      can :stats, Poll, id: Poll.expired.stats_enabled.not_budget.ids
      can :read, Poll::Question
      can :read, User
      can [:read, :welcome], Budget
      can [:read], Budget
      can [:read], Budget::Group
      can [:read, :print, :json_data], Budget::Investment
      can :read_results, Budget, id: Budget.finished.results_enabled.ids
      can :read_stats, Budget, id: Budget.valuating_or_later.stats_enabled.ids
      can :read_executions, Budget, phase: "finished"
      can :new, DirectMessage
      can [:read, :debate, :draft_publication, :allegations, :result_publication,
           :proposals, :milestones], Legislation::Process, published: true
      can :summary, Legislation::Process,
          id: Legislation::Process.past.published.where(result_publication_enabled: true).ids
      can [:read, :changes, :go_to_version], Legislation::DraftVersion
      can [:read], Legislation::Question
      can [:read, :map, :share], Legislation::Proposal
      can [:search, :comments, :read, :create, :new_comment], Legislation::Annotation

      can [:read, :help], ::SDG::Goal
      can :read, ::SDG::Phase
      can [:unselected], Budget
    end
  end
end
