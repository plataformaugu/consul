class Shared::SimpleCardComponent < ApplicationComponent
    def initialize(instance, title, description, alert, subtitle = nil)
      @instance = instance
      @title = title
      @description = description
      @alert = alert
      @subtitle = subtitle
    end
  end
  