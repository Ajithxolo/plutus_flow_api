FactoryBot.define do
  factory :expense do
    title { "Breakfast" }
    description { "egg omlet" }
    amount { 20 }
    date { "2022-01-27" }
    association :user
  end
end
