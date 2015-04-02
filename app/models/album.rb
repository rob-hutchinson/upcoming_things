class Album < ActiveRecord::Base

  has_many :favorites
  has_many :users, through: :favorites

  def favorite user
    self.favorites.create(user_id: user.id)
  end

  def unfavorite user
    fave = Favorite.where(user_id: user.id, album_id: self.id).first
    fave.delete
  end
  
end