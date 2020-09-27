# frozen_string_literal: true

class Artist < ApplicationRecord
  # ASSOCIATIONS
  has_many :albums, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  # FRIENDLY URL
  extend FriendlyId
  friendly_id :name, use: :slugged

  # VALIDATIONS
  validates :name, presence: true, uniqueness: {case_sensitive: false}

  VALID_WEBSITE_RE = %r{\Ahttps?://[\w\d\-.]*\z}.freeze
  validates :website, format: {with: VALID_WEBSITE_RE}, allow_blank: true

  # SCOPES
  scope :starts_with_letter, ->(letter) do
    where("substr(name, 1, 1) = ?", letter).order(:name)
  end

  # This complicated find-by-SQL scope is ranking results from the first part
  # of the union (artist name matches) higher than results from the second part
  # (artist description matches) by ordering first on rank and then by name.
  # Note, the virtual "rank" column added to each of the SELECT clauses means
  # UNION based deduplication will not work, hence a Ruby side "uniq" call is
  # used to deduplicate; for very large result sets this would be a problem,
  # however in this case it will be fine since there will be a limit of 250
  # records.
  scope :search, ->(query) do
    find_by_sql([<<-SQL.squish, query, query])
                   SELECT artists.*, 1 as rank
                     FROM artists
                     WHERE name @@ ?
                   UNION ALL
                   SELECT DISTINCT artists.*, 2 as rank
                     FROM artists
                     WHERE description @@ ?
                   ORDER BY rank, name ASC LIMIT 250
    SQL
      .uniq
  end

  # MODEL FILTER METHODS
  def self.list(params)
    if params.key?(:letter)
      Artist.starts_with_letter(params[:letter]).page(params[:page])
    elsif params.key?(:search)
      Kaminari.paginate_array(Artist.search(params[:search])).page(params[:page])
    else
      Artist.order(:name).page(params[:page])
    end
  end

  # VIEW HELPERS.
  #
  # Return a link with the "http(s)://(www.)" prefix stripped away.
  def website_link
    return unless website?

    @website_link ||= website.split("//")[1].sub(/^www\./, "")
  end
end
