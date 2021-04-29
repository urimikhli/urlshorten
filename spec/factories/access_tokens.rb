FactoryBot.define do
  factory :access_token do
    sequence(:token) {|n| "accesstoken#{n}" }
    association :user
  end
end
