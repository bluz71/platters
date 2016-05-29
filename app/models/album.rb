class Album < ActiveRecord::Base
  belongs_to :artist
  belongs_to :genre
  belongs_to :release_date
  has_many :tracks, dependent: :destroy

  scope :letter_prefix, -> (letter) { where("substr(title, 1, 1) = ?", letter).order(:title) }

  # TODO Replace this with a Postgres REGEXP query, something kind of like:
  #      where("title REGEXP ?", "\A\d.*\z")
  DIGIT_QUERY_STR = "substr(title, 1, 1) = ? OR " <<
                    "substr(title, 1, 1) = ? OR " <<
                    "substr(title, 1, 1) = ? OR " <<
                    "substr(title, 1, 1) = ? OR " <<
                    "substr(title, 1, 1) = ? OR " <<
                    "substr(title, 1, 1) = ? OR " <<
                    "substr(title, 1, 1) = ? OR " <<
                    "substr(title, 1, 1) = ? OR " <<
                    "substr(title, 1, 1) = ? OR " <<
                    "substr(title, 1, 1) = ?"
  scope :digit_prefix, -> { where(DIGIT_QUERY_STR, 
                                  "0", "1", "2", "3", "4", "5", "6", 
                                  "7", "8", "9").order(:title) }

  def tracks_summary
    @tracks_summary ||= tracks.limit(6).map.with_index(1) do |track, i|
      "#{i}. #{track.title}"
    end
  end
end
