class AddIndexToReleaseDateYear < ActiveRecord::Migration[5.1]
  def change
    add_index :release_dates, :year, unique: true
  end
end
