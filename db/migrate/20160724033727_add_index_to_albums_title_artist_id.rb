class AddIndexToAlbumsTitleArtistId < ActiveRecord::Migration
  def change
    add_index :albums, [:title, :artist_id], unique: true
  end
end
