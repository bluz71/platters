class ReleaseDate < ActiveRecord::Base
  has_many :albums

  validates :year, numericality: {greater_than: 1900}, uniqueness: {case_sensitive: false}
end
