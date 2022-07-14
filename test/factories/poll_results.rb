FactoryBot.define do
  factory :poll_result do
    votes_by_sector { "" }
    votes_by_gender { "" }
    votes_by_age_group { "" }
    poll { nil }
  end
end
