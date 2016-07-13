class Album < ActiveRecord::Base
  # ASSOCIATIONS
  belongs_to :artist
  belongs_to :genre
  belongs_to :release_date
  has_many :tracks, dependent: :destroy

  # FRIENDLY URL
  extend FriendlyId
  friendly_id :title, use: :slugged

  # COVER UPLOADER
  mount_uploader :cover, CoverUploader

  # VALIDATIONS
  validates :title, presence: true

  # Skip year will only be used in the model spec for performance reasons.
  attr_accessor :skip_year
  validates :year, numericality: {greater_than: 1940, less_than_or_equal_to: Date.current.year}, unless: :skip_year

  validates :genre_id, presence: true

  VALID_TRACK_RE = /\A(.+) \((\d+:\d\d)\)\z/
  validate  :track_list_format

  validate :cover_size

  # SCOPES
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

  def self.artist_albums(artist_id, params = nil)
    if params == nil || params[:newest]
      Album.includes(:artist, :genre, :release_date)
           .where(artist_id: artist_id)
           .joins(:release_date)
           .order("release_dates.year desc")
    elsif params[:oldest]
      Album.includes(:artist, :genre, :release_date)
           .where(artist_id: artist_id)
           .joins(:release_date)
           .order("release_dates.year asc")
    elsif params[:name]
      Album.includes(:artist, :genre, :release_date)
           .where(artist_id: artist_id)
           .order(:title)
    elsif params[:length]
      Album.includes(:artist, :genre, :release_date)
           .where(artist_id: artist_id)
           .joins(:tracks)
           .group(:title)
           .select("*, albums.id as id, albums.title as title, sum(tracks.duration) as album_duration")
           .order("album_duration desc")
    end
  end

  # Virtual attribute functions for form handling.

  def year
    @year ||= release_date.year if release_date
  end

  def year=(year)
    self.release_date_id = ReleaseDate.find_or_create_by(year: year).id
    @year = year
  end

  def track_list
    @track_list ||= tracks.map do |track|
      mins, secs = track.duration.divmod(60)
      "#{track.title} (#{mins}:#{secs.to_s.rjust(2, "0")})"
    end.join("\n")
  end

  def track_list=(list_of_tracks)
    @track_list = list_of_tracks

    # Clear out the existing set of tracks, the new track_list will overwrite
    # them once this model is validated and then saved.
    self.tracks.clear
  end

  # Helper functions for view information display.

  def tracks_summary
    @tracks_summary ||= tracks.limit(6).map.with_index(1) do |track, i|
      "#{i}. #{track.title}"
    end
    # Handle the edge case where an album has been defined without any tracks.
    # This will usually occur upon an album form submission with an empty
    # tracks listing.
    @tracks_summary << "No tracks" if @tracks_summary.empty?
    @tracks_summary
  end

  def total_duration
    return @total_duration if @total_duration

    mins, secs = tracks.sum(:duration).divmod(60)
    @total_duration = "#{mins}:#{secs.to_s.rjust(2, "0")}"
  end

  private

    # Validates track_list whilst also converting the track_list into the
    # individual tracks associated with this album for later saving.
    #
    # The track_list format should be a track per line with the end of the
    # track line containing the duration in parenthesis as in the following
    # example:
    #
    #  This is the first track (5:26)
    #  This is the second track (4:01)
    #
    # If track_list is not in this format then this validation will error.
    def track_list_format
      return unless @track_list

      @track_list.split("\r\n").each.with_index(1) do |track, index|
        matches = VALID_TRACK_RE.match(track)
        if matches
          mins, secs = matches[2].split(":")
          if secs.to_i < 60
            self.tracks << Track.new(title: matches[1], 
                                     number: index,
                                     duration: (mins.to_i * 60) + secs.to_i)
          else
            errors.add(:track_list,
                       "duration error, seconds can't exceed 59 for the #{index.ordinalize} track")
          end
        else
          errors.add(:track_list,
                     "format error, #{index.ordinalize} track is either missing: duration at the end of the line, or a whitespace before the duration")
        end
      end
    end

    # Validates the cover size is sane, must not be greater than 250kb. Note,
    # this cover size check occurs after it has been processed, hence why this
    # server side check (at 250kb) is different to the client side check (at
    # 2MB in app/assets/javascripts/app.album_form.coffee).
    def cover_size
      errors.add(:cover, "must be less than 250kb") if cover.size > 250.kilobytes
    end
end
