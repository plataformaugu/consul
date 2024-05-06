class Debates::FormComponent < ApplicationComponent
  include TranslatableFormHelper
  include GlobalizeHelper
  attr_reader :debate
  delegate :suggest_data, to: :helpers
  delegate :current_user, to: :helpers

  def initialize(debate, type)
    @debate = debate
    @type = type
  end
end
