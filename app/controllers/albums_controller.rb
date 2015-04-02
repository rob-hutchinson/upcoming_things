class AlbumsController < ApplicationController

  def list
    @albums = Album.all
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