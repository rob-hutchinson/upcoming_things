class AlbumsController < ApplicationController

  def list
    @albums = Album.all
    @favorites = current_user.favorites.pluck :album_id
  end

  def favorite
    album = Album.find params[:album_id].to_i
    album.favorite current_user
    redirect_to :back
    # head :ok
  end

  def unfavorite
    album = Album.find params[:album_id].to_i
    album.unfavorite current_user
    redirect_to :back
    #head :ok
  end

  def concert
    concerts = Concert.new.search "The Mountain Goats", 22201
    
    unless concerts.empty?
      @concerts = concerts
    else
      #flash message about no concerts and redirect
    redirect_to root_path
    end
  end

end