FactoryBot.define do
  factory :genre do
    sequence(:name) { |n| "Genre-#{n}" }
  end
end
