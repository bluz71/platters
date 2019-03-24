FactoryBot.define do
  factory :artist do
    sequence(:name) { |n| "Artist-#{n}" }
    description { "The artist description" }
    wikipedia { "Artist" }
    website { "http://www.artist.com" }
  end
end
