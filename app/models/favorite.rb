class Favorite < ActiveRecord::Base
validates_uniqueness_of :album_id, scope: [:user_id]
end