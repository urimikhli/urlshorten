FactoryBot.define do
  factory :shorten do
    slug { Faker::Ancient.unique.hero }
    full_url { "http://example.com/" + Faker::Ancient.unique.titan }
  end
end
