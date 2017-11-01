FactoryBot.define do
  factory :album do
    sequence(:title) { |n| "Album-#{n}" }
    genre
    skip_year true

    factory :album_with_tracks do
      transient do
        tracks_count 3
      end

      after(:create) do |album, evaluator|
        create_list(:track, evaluator.tracks_count, album: album)
      end
    end
  end
end
