class Polls::Questions::QuestionComponent < ApplicationComponent
  attr_reader :question

  def initialize(question:, can_participate: true)
    @question = question
    @can_participate = can_participate
  end

  def answers_read_more_links
    safe_join(question.answers_with_read_more.map do |answer|
      link_to answer.title, "#answer_#{answer.id}"
    end, ", ")
  end
end
