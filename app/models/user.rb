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

  def recommendations
    matching_user = find_match
    unless matching_user.nil?
    end

  end

  def find_match
    current_match = 0.1
    current_matching_users = []
    User.where("id != #{self.id}").find_each do |x|
      distance = check_distance self, x
      if distance > current_match || distance == current_match
        current_match = distance
        current_matching_users << x
      end
    return current_matching_users.sample
    end
  end

  def check_distance user1, user2
    faves_in_common = 0
    unique_albums = Favorite.uniq.pluck(:album_id)
    unique_albums.each do |x|  
      if user1.favorites.find_by(album_id: x) && user2.favorites.find_by(album_id: x)
        faves_in_common += 1
      end    
    end
    distance = (faves_in_common * faves_in_common).to_f / (user1.favorites.count * user2.favorites.count).to_f  
  end

end
