class Album < ActiveRecord::Base

  has_many :favorites
  has_many :users, through: :favorites

  def favorite user
    Favorite.create(user_id: user.id, album_id: self.id)
  end
  
end