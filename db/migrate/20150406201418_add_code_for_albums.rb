class AddCodeForAlbums < ActiveRecord::Migration
  def change
    add_column :favorites, :id_code, :string
  end
end
