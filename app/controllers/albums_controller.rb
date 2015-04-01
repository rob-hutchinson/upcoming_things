class AlbumsController < ApplicationController

  def list
    @albums = Album.all
  end

  def concert
    concerts = Concert.new.search "Matt & Kim", 22201
    unless concerts.empty?
      @concerts = concerts
    else
      #flash message about no concerts and redirect
    end
  end

end