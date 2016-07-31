class Album < ActiveRecord::Base
  # ASSOCIATIONS
  belongs_to :artist
  belongs_to :genre
  belongs_to :release_date
  has_many :tracks, dependent: :destroy

  # FRIENDLY ID
  extend FriendlyId
  friendly_id :title, use: :slugged

  # COVER UPLOADER
  mount_uploader :cover, CoverUploader

  # VALIDATIONS
  validates :title, presence: true, uniqueness: {scope: :artist_id}

  # Skip year will only be used in the model spec for performance reasons.
  attr_accessor :skip_year
  validates :year, numericality: {greater_than: 1950, less_than_or_equal_to: Date.current.year}, unless: :skip_year

  validates :genre_id, presence: true

  VALID_TRACK_RE = /\A(.+) \((\d+:\d\d)\)\z/
  validate  :track_list_format

  validate :cover_size

  # SCOPES

  # Eager loading of assocations to avoid N+1 performance issue.
  scope :associations, -> { includes(:artist, :genre, :release_date) }

  scope :starts_with_letter, -> (letter) do
    where("substr(title, 1, 1) = ?", letter).order(:title)
  end

  # This complicated find-by-SQL scope is ranking results from the first part
  # of the union (album title matches) higher than results from the second part
  # (track title matches) by ordering first on rank and then by title.  Note,
  # the virtual "rank" column added to each of the SELECT clauses means UNION
  # based deduplication will not work, hence a Ruby side "uniq" call is used to
  # deduplicate; for very large result sets this would be a problem, however in
  # this case it will be fine since there will be a limit of 250 records.
  #
  # XXX, for Postgres use ILIKE instead of LIKE for case-insensitive searches.
  scope :search, -> (query) do
    find_by_sql([<<-SQL.squish, "%#{query}%", "%#{query}%"])
                   SELECT albums.*, 1 as rank
                     FROM albums
                     WHERE title LIKE ?
                   UNION ALL
                   SELECT DISTINCT albums.*, 2 as rank
                     FROM albums
                     JOIN tracks ON tracks.album_id = albums.id
                     WHERE tracks.title LIKE ?
                   ORDER BY rank, albums.title ASC LIMIT 250
                 SQL
      .uniq
  end

  scope :with_genre, -> (genre_id) { where(genre_id: genre_id).order(:title) }

  scope :with_release_date, -> (release_date_id) do
    where(release_date_id: release_date_id).order(:title)
  end

  scope :newest_artist_albums, -> (artist_id) do
    where(artist_id: artist_id).joins(:release_date).order("release_dates.year DESC")
  end

  scope :oldest_artist_albums, -> (artist_id) do
    where(artist_id: artist_id).joins(:release_date).order("release_dates.year ASC")
  end

  scope :longest_artist_albums, -> (artist_id) do
    where(artist_id: artist_id)
      .joins(:tracks)
      .group(:title)
      .select("*, albums.id as id, albums.title as title, sum(tracks.duration) as album_duration")
      .order("album_duration DESC")
  end

  # MODEL FILTER METHODS
  def self.list(params, per_page)
    if params.key?(:letter)
      Album.associations.starts_with_letter(params[:letter])
           .page(params[:page]).per(per_page)
    elsif params.key?(:search)
      albums = Album.search(params[:search])
      # Album.search uses a find_by_sql query hence eager loading via the
      # includes method does not work, instead, for Rails 4, one needs to do
      # the following Preloader magic. Information about this refer to:
      #   http://cha1tanya.com/2013/10/26/preload-associations-with-find-by-sql.html
      ActiveRecord::Associations::Preloader.new.preload(albums, [:artist, :genre, :release_date])
      Kaminari.paginate_array(albums).page(params[:page]).per(per_page)
    elsif params.key?(:genre)
      genre_id = Genre.find_by(name: params[:genre])
      Album.associations.with_genre(genre_id).page(params[:page]).per(per_page)
    elsif params.key?(:release_date)
      release_date_id = ReleaseDate.find_by(year: params[:release_date])
      Album.associations.with_release_date(release_date_id)
           .page(params[:page]).per(per_page)
    else
      Album.associations.order(:title).page(params[:page]).per(per_page)
    end
  end

  def self.artist_albums(artist_id, params = nil)
    if params == nil || params[:newest]
      Album.associations.newest_artist_albums(artist_id)
    elsif params[:oldest]
      Album.associations.oldest_artist_albums(artist_id)
    elsif params[:longest]
      Album.associations.longest_artist_albums(artist_id)
    elsif params[:name]
      Album.associations.where(artist_id: artist_id).order(:title)
    end
  end

  # FORM RELATED VIRTUAL ATTRIBUTES
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

  # VIEW HELPERS.
  def tracks_summary
    @tracks_summary ||= tracks.limit(6).map.with_index(1) do |track, i|
      "#{i}. #{track.title}"
    end

    @tracks_summary << "..." if tracks.count > 6

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
