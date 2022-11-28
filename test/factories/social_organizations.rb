FactoryBot.define do
  factory :social_organization do
    name { "MyString" }
    description { "MyText" }
    email { "MyString" }
    url { "MyString" }
    user { nil }
  end
end
