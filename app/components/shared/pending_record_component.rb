class Shared::PendingRecordComponent < ApplicationComponent
  def initialize(title, text, record)
    @title = title
    @text = text
    @record = record
  end
end
