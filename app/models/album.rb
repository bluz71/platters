# frozen_string_literal: true

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

  validate  :track_list_format

  validate :cover_size

  # SCOPES

  # Eager load assocations to avoid N+1 performance issue.
  scope :including, -> { includes(:artist, :genre, :release_date) }

  # Note, the chosen form of randomization is usually more performant than this:
  #   order("RANDOM()").limit(20)
  scope :random, -> { where(id: Album.pluck(:id).sample(20)).order("RANDOM()") }

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
  # Note, for performance reasons the secondary track title search is a simple
  # ILIKE query rather than a full-text query, this results in a about a 100ms
  # speed improvement.
  scope :search, -> (query) do
    find_by_sql([<<-SQL.squish, query, "%#{query}%"])
                   SELECT albums.*, 1 as rank
                     FROM albums
                     WHERE title @@ ?
                   UNION ALL
                   SELECT DISTINCT albums.*, 2 as rank
                     FROM albums
                     JOIN tracks ON tracks.album_id = albums.id
                     WHERE tracks.title ILIKE ?
                   ORDER BY rank, title ASC LIMIT 250
                 SQL
      .uniq
  end

  scope :with_genre, -> (genre) do
    joins(:genre).where("genres.name = ?", genre)
  end

  scope :with_release_date, -> (release_dates) do
    joins(:release_date).where("release_dates.year IN (?)", release_dates)
  end

  scope :sort_by_year, -> (direction) do
    joins(:release_date).order("release_dates.year #{direction == :desc ? "DESC" : "ASC"}")
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
      .group("albums.id")
      .select(<<-SQL.squish)
                albums.id as id, 
                albums.title as title, 
                albums.artist_id as artist_id, 
                albums.genre_id as genre_id, 
                albums.release_date_id as release_date_id,
                albums.cover as cover,
                albums.slug as slug,
                sum(tracks.duration) as album_duration
              SQL
      .order("album_duration DESC")
  end

  scope :most_recent, -> do
    joins(:release_date).where("release_dates.year IN (?)",
                               [Date.current.year, Date.current.year - 1])
      .order("release_dates.year DESC").order(updated_at: :desc).limit(6)
  end

  # MODEL FILTER METHODS

  YEAR_RANGE_RE = /\d{4}\.\.\d{4}\z/
  def self.list(params, per_page = 20)
    if params.key?(:search)
      albums = Album.search(params[:search])
      # Album.search uses a find_by_sql query hence eager loading via the
      # includes method does not work, instead, for Rails 4, one needs to do
      # the following Preloader magic. Information about this refer to:
      #   http://cha1tanya.com/2013/10/26/preload-associations-with-find-by-sql.html
      ActiveRecord::Associations::Preloader.new.preload(albums, [:artist, :genre, :release_date])
      return Kaminari.paginate_array(albums).page(params[:page]).per(per_page)
    end

    scopes = Album.including

    if params.key?(:random) && params[:random]
      return scopes.random.page(1).per(per_page)
    end

    if params.key?(:letter)
      scopes = scopes.starts_with_letter(params[:letter])
    end

    if params.key?(:genre) && params[:genre].present?
      scopes = scopes.with_genre(params[:genre])
    end

    if params.key?(:year) && params[:year].present?
      years = []
      params[:year].split(",").each do |year|
        if YEAR_RANGE_RE.match(year)
          years += eval(year).to_a
        else
          years << year.to_i
        end
      end
      scopes = scopes.with_release_date(years)
    end

    direction = :asc
    if params.key?(:order) && params[:order] == "reverse"
      direction = :desc
    end

    if params.key?(:sort) && params[:sort] == "year"
      scopes = scopes.sort_by_year(direction)
    elsif params[:sort] == "title" || !params.key?(:sort)
      scopes = scopes.order(title: direction)
    end

    scopes.page(params[:page]).per(per_page)
  end

  def self.artist_albums(artist_id, params = nil)
    if params == nil || params[:newest]
      Album.including.newest_artist_albums(artist_id)
    elsif params[:oldest]
      Album.including.oldest_artist_albums(artist_id)
    elsif params[:longest]
      Album.including.longest_artist_albums(artist_id)
    elsif params[:name]
      Album.including.where(artist_id: artist_id).order(:title)
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
    # If track_list is not in this format then this validation will error.
    def track_list_format
      return unless @track_list

      @track_list.split("\r\n").each.with_index(1) do |track, index|
        Track.parse_form_track(track, index, tracks, errors)
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
