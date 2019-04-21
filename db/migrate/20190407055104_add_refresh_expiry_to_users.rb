class AddRefreshExpiryToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :api_token_refresh_expiry, :datetime
  end
end
