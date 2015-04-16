class Album < ActiveRecord::Base

  has_many :favorites
  has_many :users, through: :favorites
  
  def spotify_deets
    Album.find_each do |album|
      artist = album.artist.downcase
      response = HTTParty.get("https://api.spotify.com/v1/search", query: {"q"=>"#{artist}", "type"=>"artist"})
      unless response["artists"]["items"].empty?
        first_response = response["artists"]["items"].first
        if first_response["name"].downcase == artist && first_response["images"][1].nil?
          album.update(
            spotify_id: first_response["id"],
            spotify_details: first_response["href"])
        elsif first_response["name"].downcase == artist  
          album.update(
            thumbnail: first_response["images"][1]["url"],
            spotify_id: first_response["id"],
            spotify_details: first_response["href"])
        end
      end
    end
  end
end