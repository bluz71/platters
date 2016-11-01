class AddEmailConfirmationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :email_confirmation_token, :string
    add_column :users, :email_confirmed_at, :datetime
  end
end
