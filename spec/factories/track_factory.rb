FactoryBot.define do
  factory :track do
    sequence(:title) { |n| "Track-#{n}" }
    sequence(:number) { |n| n }
    duration { 188 }
  end
end
