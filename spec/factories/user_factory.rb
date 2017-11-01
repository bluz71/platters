FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password "password9"
    sequence(:name) { |n| "name#{n}" }
    email_confirmed_at Time.current

    factory :admin do
      admin true
    end
  end
end
