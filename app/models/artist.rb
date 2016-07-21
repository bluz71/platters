class Artist < ActiveRecord::Base
  # ASSOCIATIONS
  has_many :albums, dependent: :destroy

  # FRIENDLY URL
  extend FriendlyId
  friendly_id :name, use: :slugged

  # VALIDATIONS
  validates :name, presence: true, uniqueness: {case_sensitive: false}
  VALID_WEBSITE_RE = /\Ahttps?:\/\/[\w\d\-\.]*\z/
  validates :website, format: {with: VALID_WEBSITE_RE}, allow_blank: true

  # SCOPES
  scope :letter_prefix, -> (letter) { where("substr(name, 1, 1) = ?", letter).order(:name) }

  # XXX, with Postgres use ILIKE instead of LIKE since we want case-insensitive
  # searches.
  scope :search, -> (query) do
    where("name LIKE ? OR description LIKE ?", "%#{query}%", "%#{query}%")
      .order(:name)
  end

  # MODEL FILTER METHODS
  def self.filtered(params)
    if params[:letter]
      Artist.letter_prefix(params[:letter]).page(params[:page])
    elsif params[:search]
      Artist.search(params[:search]).page(params[:page])
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
