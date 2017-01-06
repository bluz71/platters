class AddIndexToCommentsCreatedAt < ActiveRecord::Migration[5.0]
  def change
    add_index :comments, :created_at
  end
end
