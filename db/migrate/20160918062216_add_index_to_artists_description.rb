class AddIndexToArtistsDescription < ActiveRecord::Migration[5.1]
  def change
    add_index :artists, :description
  end
end
