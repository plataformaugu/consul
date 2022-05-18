FactoryBot.define do
  factory :proposals_theme do
    title { "MyString" }
    description { "MyText" }
    image { "MyString" }
    start_date { "2022-05-17" }
    end_date { "2022-05-17" }
    is_public { false }
  end
end
