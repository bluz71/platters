class AddIndexToArtistsDescription < ActiveRecord::Migration
  def change
    add_index :artists, :description
  end
end
