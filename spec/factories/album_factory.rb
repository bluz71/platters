FactoryGirl.define do
  factory :album do
    sequence(:title) { |n| "Album-#{n}" }
    genre
    skip_year true
  end
end
