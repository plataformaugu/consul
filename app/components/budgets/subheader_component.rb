class Budgets::SubheaderComponent < ApplicationComponent
  delegate :current_user, :link_to_signin, :link_to_signup, :link_to_verify_account, :can?, to: :helpers
  attr_reader :budget

  def initialize(budget)
    @budget = budget
  end

  def can_participate_and_reason
    can_participate = true
    reason = nil

    if !current_user.administrator? && @budget.segmentation.present?
      can_participate, reason = @budget.segmentation.validate(current_user)
    end

    return [can_participate, reason]
  end
end
