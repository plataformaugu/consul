module Abilities
  class Manager
    include CanCan::Ability

    def initialize(user)
      merge Abilities::Common.new(user)

      can :suggest, Budget::Investment

      can :find_user_by_document_number, User

      can :vote_manager_form, Proposal
      can :vote_manager_existing_user, Proposal
      can :vote_manager_new_user, Proposal

      can :participate_manager_form, Event
      can :participate_manager_existing_user, Event
      can :participate_manager_new_user, Event

      can :participate_manager_form, Survey
      can :participate_manager_existing_user, Survey
      can :participate_manager_new_user, Survey
    end
  end
end
