module Abilities
  class Manager
    include CanCan::Ability

    def initialize(user)
      merge Abilities::Common.new(user)

      can :suggest, Budget::Investment

      can :find_user_by_document_number, User

      can :participate_manager_form, Survey
      can :participate_manager_existing_user, Survey
      can :participate_manager_new_user, Survey
    end
  end
end
