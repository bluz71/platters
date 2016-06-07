class Album < ActiveRecord::Base
  belongs_to :artist
  belongs_to :genre
  belongs_to :release_date
  has_many :tracks, dependent: :destroy

  validates :title, presence: true
  validates :tracks_list, presence: true
  validate  :tracks_list_format

  after_commit :persist_tracks_list

  attr_reader :tracks_list, :year

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

  VALID_TRACK_RE = /\A.+ \(\d+:\d\d\)\z/

  def self.artist_albums(artist_id)
    Album.includes(:genre, :release_date)
         .where(artist_id: artist_id)
         .joins(:release_date)
         .order("release_dates.year desc")
  end

  # Virtual attribute functions for form handling.
  def year=(year)
    @year = year
    self.release_date_id = ReleaseDate.find_or_create_by(year: year).id
  end

  def tracks_list=(list_of_tracks)
    @tracks_list = list_of_tracks
  end

  # Helper functions for view information display.
  def tracks_summary
    @tracks_summary ||= tracks.limit(6).map.with_index(1) do |track, i|
      "#{i}. #{track.title}"
    end
  end

  def total_duration
    return @total_duration if @total_duration
    mins, secs = tracks.sum(:duration).divmod(60)
    @total_duration = "#{mins}:#{secs.to_s.rjust(2, "0")}"
  end

  private

    # Validates the format of a list of tracks submitted from a new album form
    # submission. The format should be a track per line with the end of the
    # track line containing the duration in parenthesis as in the following
    # example:
    #
    #  This is the first track (5:26)
    #  This is the second track (4:01)
    def tracks_list_format
      @tracks_list.split("\n").each do |track|
        errors.add(:tracks_list, "invalid format") unless VALID_TRACK_RE.match(track)
      end
    end

    def persist_tracks_list
      @tracks_list.split("\n").each_with_index do |track, i|
        self.tracks.create(title: track, number: 1, duration: 0)
      end
    end
end
