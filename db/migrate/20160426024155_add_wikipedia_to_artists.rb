class AddWikipediaToArtists < ActiveRecord::Migration
  def change
    add_column :artists, :wikipedia, :string
  end
end
