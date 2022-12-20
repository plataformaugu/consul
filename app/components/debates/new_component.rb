class Debates::NewComponent < ApplicationComponent
  include Header
  attr_reader :debate
  delegate :current_user, to: :helpers

  def initialize(debate)
    @debate = debate
  end

  def title
    t("debates.new.start_new")
  end
end
