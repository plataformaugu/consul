class Surveys::UniqueComponent < ApplicationComponent
  def initialize(survey_item)
    @survey_item = survey_item
  end
end
