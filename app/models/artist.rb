class Artist < ActiveRecord::Base
  has_many :albums, dependent: :destroy

  validates :name, presence: true, uniqueness: {case_sensitive: false}

  scope :by_letter, -> (letter) { where("substr(name, 1, 1) = ?", letter).order(:name) }

  # Return a link with the "http(s)://(www.)" prefix stripped away.
  def website_link
    return unless website?
    @website_link ||= website.split("//")[1].sub(/^www\./, "")
  end
end
