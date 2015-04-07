class AddsRefreshTimer < ActiveRecord::Migration
  def change
    add_column :users, :token_refreshes_at, :integer
  end
end
