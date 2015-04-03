class AddAuthDataForUsers < ActiveRecord::Migration
  def change
    add_column :users, :user_token, :string
    add_column :users, :user_refresh_token, :string
    add_column :users, :auth_data, :text
    add_column :users, :zip_code, :integer
  end
end
