class Moderation::Budgets::InvestmentsController < Moderation::BaseCustomController

  private

    def pronoun_vowel
      'o'
    end

    def readable_model
      'proyecto'
    end

    def resource_model
      Budget::Investment
    end

    def get_records
      Budget::Investment.where(published_at: nil)
    end
end
