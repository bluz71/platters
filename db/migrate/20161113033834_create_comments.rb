class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.text :body
      t.integer :commentable_id, index: true
      t.string :commentable_type
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
