class AddIndexToReleaseDateYear < ActiveRecord::Migration
  def change
    add_index :release_dates, :year, unique: true
  end
end
