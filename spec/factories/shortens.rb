FactoryBot.define do
  factory :shorten do
    slug { "slug" }
    full_url { "Full/URL/this/can/be/long" }
  end
end
