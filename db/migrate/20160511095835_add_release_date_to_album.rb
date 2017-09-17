class AddReleaseDateToAlbum < ActiveRecord::Migration[5.1]
  def change
    add_reference :albums, :release_date, index: true, foreign_key: true
  end
end
