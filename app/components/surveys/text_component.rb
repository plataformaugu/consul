class Surveys::TextComponent < ApplicationComponent
  delegate :current_user, to: :helpers

  def initialize(survey_item)
    @survey_item = survey_item
    @survey = survey_item.survey
  end

  def is_disabled
    return @survey.is_expired? || @survey.answered_by_user?(current_user)
  end

  def answers
    if @survey_item.answers.where(user: current_user).exists?
      return @survey_item.answers.where(user: current_user).first.data
    else
      return nil
    end
  end
end
