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
end
