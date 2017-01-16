# frozen_string_literal: true

class ReleaseDate < ApplicationRecord
  has_many :albums

  validates :year, numericality: {greater_than: 1950, 
                                  less_than_or_equal_to: Date.current.year},
                   uniqueness: {case_sensitive: false}
end
