class ReleaseDate < ActiveRecord::Base
  has_many :albums

  validates :year, numericality: {greater_than: 1940, less_than_or_equal_to: Date.current.year}, uniqueness: {case_sensitive: false}
end
