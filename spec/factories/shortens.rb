FactoryBot.define do
  factory :shorten do
    slug { I18n.transliterate(Faker::Ancient.unique.hero) }
    full_url { "http://example.com/" + Faker::Ancient.titan }
    association :user
  end
end
