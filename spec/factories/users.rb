FactoryBot.define do
  factory :user do
    sequence(:login) {|n| "user#{n}" }
    name { Faker::Name.name }
    avatar_url  { "http://example.com/avatar" }
    provider  { "github" }
  end
end