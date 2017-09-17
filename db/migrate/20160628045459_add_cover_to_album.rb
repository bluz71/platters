class AddCoverToAlbum < ActiveRecord::Migration[5.1]
  def change
    add_column :albums, :cover, :string
  end
end
