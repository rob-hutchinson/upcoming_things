class AddAlbumDetails < ActiveRecord::Migration
  def change
    add_column :albums, :spotify_id, :string
    add_column :albums, :spotify_details, :string
  end
end
