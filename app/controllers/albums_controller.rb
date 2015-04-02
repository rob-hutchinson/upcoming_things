class AlbumsController < ApplicationController

  def list
    @albums = Album.all
    @favorites = current_user.favorites.pluck :album_id
  end

  def favorite
    album = Album.find params[:album_id].to_i
    album.favorite current_user
    head :ok
  end

  def unfavorite
    album = Album.find params[:album_id].to_i
    album.unfavorite current_user
    head :ok
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