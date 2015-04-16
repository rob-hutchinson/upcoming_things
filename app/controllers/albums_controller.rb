class AlbumsController < ApplicationController

  def list
    @albums = Album.all
    @favorites = current_user.favorites.pluck :album_id
    unless current_user.recommendation.nil?
      @recommended = Album.find(current_user.recommendation)
      @flash = "Hey, you've got great taste in music! Have you considered giving #{@recommended.artist} a listen?"
    end
  end

  def favorite
    album = Album.find params[:album_id].to_i
    current_user.favorite album
    Calendar.new.add_album current_user, album
    head :ok
  end

  def unfavorite
    album = Album.find params[:album_id].to_i
    event_id = Favorite.find_by(user_id: current_user.id, album_id: album.id).id_code
    Calendar.new.delete_event current_user, event_id
    current_user.unfavorite album
    head :ok
  end

  def add_concert
    Calendar.new.add_concert current_user, params["format"]
  end

  def concert
    faves = current_user.favorites.pluck(:album_id)
    artists = faves.map { |x| Album.find(x).artist }
    
    if current_user.zip_code.nil?
      # flash[:alert] = "Please enter your zip code to search for concerts!"
      @flash = "Please enter your zip code to search for concerts!"
      return :ok
    else
      concerts = Concert.new.search artists, current_user.zip_code
      concerts.sort_by! { |x| x["start_time"] }
    end

    unless concerts.empty?
      @concerts = concerts
    else
      @flash = "No concerts were found for your favorite artists. Sorry!"
    end
  end

end