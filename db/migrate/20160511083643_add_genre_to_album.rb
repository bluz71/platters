class AddGenreToAlbum < ActiveRecord::Migration
  def change
    add_reference :albums, :genre, index: true, foreign_key: true
  end
end
