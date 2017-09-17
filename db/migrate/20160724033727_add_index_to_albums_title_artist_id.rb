class AddIndexToAlbumsTitleArtistId < ActiveRecord::Migration[5.1]
  def change
    add_index :albums, [:title, :artist_id], unique: true
  end
end
