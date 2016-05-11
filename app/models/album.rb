class Album < ActiveRecord::Base
  belongs_to :artist
  belongs_to :genre
  belongs_to :release_date
end
