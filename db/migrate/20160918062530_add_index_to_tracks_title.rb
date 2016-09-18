class AddIndexToTracksTitle < ActiveRecord::Migration
  def change
    add_index :tracks, :title
  end
end
