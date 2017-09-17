class AddDescriptionToArtists < ActiveRecord::Migration[5.1]
  def change
    add_column :artists, :description, :text
  end
end
