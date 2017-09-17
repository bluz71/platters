class CreateTracks < ActiveRecord::Migration[5.1]
  def change
    create_table :tracks do |t|
      t.string :title
      t.integer :number
      t.integer :duration
      t.references :album, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
