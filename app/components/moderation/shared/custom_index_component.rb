class Moderation::Shared::CustomIndexComponent < ApplicationComponent
  attr_reader :records

  def initialize(records, model_name, publish_path, edit_path = nil, user_field = 'author', methods_key_arguments = ['id'])
    @records = records
    @model_name = model_name
    @publish_path = publish_path
    @edit_path = edit_path
    @user_field = user_field
    @methods_key_arguments = methods_key_arguments
  end

  private

    def author(record)
      author_data = nil

      if !@user_field.nil?
        author_data = record.send(@user_field)
      end

      return author_data
    end
end
