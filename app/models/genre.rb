# frozen_string_literal: true

class Genre < ApplicationRecord
  has_many :albums

  validates :name, presence: true, uniqueness: {case_sensitive: false}
end
