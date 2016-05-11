class CreateReleaseDates < ActiveRecord::Migration
  def change
    create_table :release_dates do |t|
      t.integer :year

      t.timestamps null: false
    end
  end
end
