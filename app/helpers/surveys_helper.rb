module SurveysHelper
  def get_unique_type_results(item)
    return item.answers.pluck(:data).filter { |value| value != '' }.tally.to_a
  end

  def get_multiple_type_results(item)
    return item.answers.pluck(:data).flatten.tally.to_a
  end

  def get_ranking_type_results(item)
    ranking_answers = item.answers.pluck(:data)
    result = item.data.map { |value| [value, []] }.to_h

    ranking_answers.each do |ranking_answer|
      ranking_answer.each_with_index do |ranking_answer_item, index|
        result[ranking_answer_item].push(index)
      end
    end

    final_result = []

    result.map do |ranking_key, ranking_positions|
      ranking_positions_count = ranking_positions.count
      
      if ranking_positions_count > 0
        ranking_average = ranking_positions.sum / ranking_positions_count
      else
        ranking_average = ranking_positions.sum / 1
      end

      final_result.push([ranking_key, ranking_average])
    end

    final_result = final_result.to_h.sort_by { |_, value| value }.to_h.keys

    return final_result
  end
end
