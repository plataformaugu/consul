class Debates::NewComponent < ApplicationComponent
  include Header
  attr_reader :debate

  def initialize(debate, type)
    @debate = debate
    @type = type
  end

  def title
    t("debates.new.start_new")
  end
end
