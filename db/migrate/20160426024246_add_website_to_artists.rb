class AddWebsiteToArtists < ActiveRecord::Migration[5.1]
  def change
    add_column :artists, :website, :string
  end
end
