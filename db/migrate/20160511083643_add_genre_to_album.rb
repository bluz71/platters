class AddGenreToAlbum < ActiveRecord::Migration[5.1]
  def change
    add_reference :albums, :genre, index: true, foreign_key: true
  end
end
