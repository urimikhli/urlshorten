FactoryBot.define do
  factory :shorten do
    slug { Faker::Ancient.unique.hero }
    full_url { "Full/URL/this/can/be/long/" + Faker::Ancient.unique.titan }
  end
end
