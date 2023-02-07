class Debates::FormComponent < ApplicationComponent
  include TranslatableFormHelper
  include GlobalizeHelper
  attr_reader :debate
  delegate :current_user, :suggest_data, to: :helpers

  def initialize(debate)
    @debate = debate
  end
end
