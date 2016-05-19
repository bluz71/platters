class Album < ActiveRecord::Base
  belongs_to :artist
  belongs_to :genre
  belongs_to :release_date
  has_many :tracks, dependent: :destroy

  scope :by_letter, -> (letter) { where("substr(title, 1, 1) = ?", letter).order(:title) }
end
