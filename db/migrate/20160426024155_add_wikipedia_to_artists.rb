class AddWikipediaToArtists < ActiveRecord::Migration[5.1]
  def change
    add_column :artists, :wikipedia, :string
  end
end
