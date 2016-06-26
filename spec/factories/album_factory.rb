FactoryGirl.define do
  factory :album do
    sequence(:title) { |n| "Track-#{n}" }
    genre
    year 2001

    factory :album_with_tracks do
      transient do
        tracks_count 3
      end

      after(:create) do |album, evaluator|
        build_stubbed_list(:track, evaluator.tracks_count, album: album)
      end
    end
  end
end
