class AlbumsController < ApplicationController

  def list
    @albums = Album.all
    @favorites = current_user.favorites.pluck :album_id
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
    binding.pry
    Calendar.new.add_concert current_user, params
  end

  def concert
    faves = current_user.favorites.pluck(:album_id)
    artists = faves.map { |x| Album.find(x).artist }
    
    concerts = Concert.new.search artists, 22201

    unless concerts.empty?
      @concerts = concerts
    else
      #flash message about no concerts and redirect
    redirect_to root_path
    end
  end

end