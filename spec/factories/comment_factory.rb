FactoryGirl.define do
  factory :comment do
    body "Comment body"
    user

    factory :comment_for_artist do
      association :commentable, factory: :artist
    end

    factory :comment_for_album do
      association :commentable, factory: :album
    end
  end
end
