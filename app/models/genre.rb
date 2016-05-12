class Genre < ActiveRecord::Base
  has_many :albums

  validates :name, presence: true, uniqueness: {case_sensitive: false}
end
