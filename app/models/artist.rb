class Artist < ActiveRecord::Base
  has_many :albums, dependent: :destroy

  validates :name, presence: true, uniqueness: {case_sensitive: false}

  scope :by_letter, -> (letter) { where("substr(name, 1, 1) = ?", letter).order(:name) }

  # TODO Replace this with a Postgres REGEXP query, something kind of like:
  #      where("name REGEXP ?", "\A\d.*\z")
  BY_DIGIT_QUERY_STR = "substr(name, 1, 1) = ? OR " +
                       "substr(name, 1, 1) = ? OR " +
                       "substr(name, 1, 1) = ? OR " +
                       "substr(name, 1, 1) = ? OR " +
                       "substr(name, 1, 1) = ? OR " +
                       "substr(name, 1, 1) = ? OR " +
                       "substr(name, 1, 1) = ? OR " +
                       "substr(name, 1, 1) = ? OR " +
                       "substr(name, 1, 1) = ? OR " +
                       "substr(name, 1, 1) = ?"
  scope :by_digit, -> { where(BY_DIGIT_QUERY_STR, 
                              "0", "1", "2", "3", "4", "5", "6",
                              "7", "8", "9").order(:name) }

  # Return a link with the "http(s)://(www.)" prefix stripped away.
  def website_link
    return unless website?
    @website_link ||= website.split("//")[1].sub(/^www\./, "")
  end
end
