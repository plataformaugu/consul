class Moderation::DebatesController < Moderation::BaseCustomController

  private

    def pronoun_vowel
      'o'
    end

    def readable_model
      'debate'
    end

    def resource_model
      Debate
    end

    def get_records
      Debate.where(published_at: nil)
    end
end
