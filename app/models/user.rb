class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :registerable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :favorites
  has_many :albums, through: :favorites
  
  serialize :google_auth_data, JSON

  def self.from_omniauth auth
    email = auth.info.email
  
    where(email: email).first_or_create! do |u|
      u.password = SecureRandom.hex 64
      u.user_token = auth["credentials"]["token"]
      u.user_refresh_token = auth["credentials"]["refresh_token"]
      u.token_refreshes_at = auth["credentials"]["expires_at"]
      u.auth_data = auth
    end
  end

  def recommendation
    matching_user = find_match
    recommendations = []
    
    Favorite.find_each do |x|
      if matching_user.favorites.include?(x) && self.favorites
        .exclude?(Favorite.find_by(album_id: x.album_id, user_id: self.id))
        recommendations << x
      end
    end

    unless recommendations.empty?
      return recommendations.sample.album_id
    else
      return nil
      #Do something else? Compliment their music taste?
    end
  end

  def find_match
    matching_users = []
    User.where("id != #{self.id}").find_each do |x|
      distance = check_distance x
      matching_users << [distance, x]
    end
    matching_users.sort!.last[1]
  end

  def check_distance other_user
    faves_in_common = 0
    unique_albums = Favorite.uniq.pluck(:album_id)
    unique_albums.each do |x|  
      if self.favorites.find_by(album_id: x) && other_user.favorites.find_by(album_id: x)
        faves_in_common += 1
      end    
    end
    
    unless self.favorites.count == 0 || other_user.favorites.count == 0
      distance = (faves_in_common * faves_in_common).to_f / (self.favorites.count * other_user.favorites.count).to_f  
    else
      distance = 0.0
    end
  end

end
