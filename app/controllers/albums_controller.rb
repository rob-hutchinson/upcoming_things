class AlbumsController < ApplicationController

  def list
    @albums = Album.all
  end


end