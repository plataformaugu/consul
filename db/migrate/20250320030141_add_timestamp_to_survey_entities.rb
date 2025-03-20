class AddTimestampToSurveyEntities < ActiveRecord::Migration[6.0]
  def change
    add_timestamps :survey_items, default: Time.zone.now
    change_column_default :survey_items, :created_at, nil
    change_column_default :survey_items, :updated_at, nil

    add_timestamps :survey_item_answers, default: Time.zone.now
    change_column_default :survey_item_answers, :created_at, nil
    change_column_default :survey_item_answers, :updated_at, nil
  end
end
