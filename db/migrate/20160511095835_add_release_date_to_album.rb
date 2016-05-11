class AddReleaseDateToAlbum < ActiveRecord::Migration
  def change
    add_reference :albums, :release_date, index: true, foreign_key: true
  end
end
