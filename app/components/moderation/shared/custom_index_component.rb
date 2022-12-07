class Moderation::Shared::CustomIndexComponent < ApplicationComponent
  attr_reader :records

  def initialize(records, model_name, publish_path, edit_path = nil, user_field = 'author')
    @records = records
    @model_name = model_name
    @publish_path = publish_path
    @edit_path = edit_path
    @user_field = user_field
  end

  private

    def author(record)
      record.send(@user_field)
    end
end
