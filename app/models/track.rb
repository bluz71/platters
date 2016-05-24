class Track < ActiveRecord::Base
  belongs_to :album

  validates :title, presence: true
  validates :number, numericality: {greater_than: 0, less_than: 150}
end
