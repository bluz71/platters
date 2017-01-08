class AddCounterCaches < ActiveRecord::Migration[5.0]
  def change
    add_column :artists, :albums_count, :integer, default: 0
    add_column :artists, :comments_count, :integer, default: 0
    add_column :albums, :tracks_count, :integer, default: 0
    add_column :albums, :comments_count, :integer, default: 0
  end
end
