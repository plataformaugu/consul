FactoryBot.define do
  factory :neighborhood_council_event do
    name { "MyString" }
    place { "MyString" }
    email { "MyString" }
    phone_number { "MyString" }
    neighborhood_council { nil }
    event { nil }
  end
end
