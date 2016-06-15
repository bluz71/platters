class Album < ActiveRecord::Base
  belongs_to :artist
  belongs_to :genre
  belongs_to :release_date
  has_many :tracks, dependent: :destroy

  validates :title, presence: true
  validates :year, presence: true, numericality: {greater_than: 1900}

  VALID_TRACK_RE = /\A(.+) \((\d+:\d\d)\)\z/
  validate  :tracks_list_format

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

  def self.artist_albums(artist_id)
    Album.includes(:genre, :release_date)
         .where(artist_id: artist_id)
         .joins(:release_date)
         .order("release_dates.year desc")
  end

  # Virtual attribute functions for form handling.

  def year
    @year ||= release_date.year if release_date
  end

  def year=(year)
    self.release_date_id = ReleaseDate.find_or_create_by(year: year).id
    @year = year
  end

  def tracks_list
    @tracks_list ||= tracks.map do |track|
      mins, secs = track.duration.divmod(60)
      "#{track.title} (#{mins}:#{secs.to_s.rjust(2, "0")})"
    end.join("\n")
  end

  def tracks_list=(list_of_tracks)
    @tracks_list = list_of_tracks

    # Clear out the existing set of tracks, the new tracks_list will overwrite
    # them once this model is validated and then saved.
    self.tracks.clear
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

    # Validates tracks_list whilst also converting the tracks_list into the
    # individual tracks associated with this album for later saving.
    #
    # The tracks_list format should be a track per line with the end of the
    # track line containing the duration in parenthesis as in the following
    # example:
    #
    #  This is the first track (5:26)
    #  This is the second track (4:01)
    #
    # If tracks_list is not in this format then this validation will error.
    def tracks_list_format
      return unless @tracks_list

      @tracks_list.split("\r\n").each.with_index(1) do |track, index|
        matches = VALID_TRACK_RE.match(track)
        if matches
          mins, secs = matches[2].split(":")
          if secs.to_i > 60
            errors.add(:tracks_list,
                       "was supplied with invalid seconds of #{secs}")
            self.tracks.clear
            break
          end
          self.tracks << Track.new(title: matches[1], 
                                   number: index,
                                   duration: (mins.to_i * 60) + secs.to_i)
        else
          errors.add(:tracks_list,
                     "invalid track was entered, please append bracketed track duration, (mins:secs), at the end of each line")
          self.tracks.clear
          break
        end
      end
    end
end
