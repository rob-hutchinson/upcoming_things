class Concert

  def search artist, zipcode
    concerts = []
    artist_query = artist.split(" ").join("+")
    
    data = HTTParty.get("http://api.eventful.com/rest/events/search?category=music&
    sort_order=date&location=#{zipcode}&within=25&date=future&page_size=100
    &keywords=#{artist_query}", query: {"app_key"=> Figaro.env.eventful_key})
    
    all_events = data["search"]["events"]["event"]

    unless data.count < 2
      all_events.each do |x|
        if x["title"] == artist || x["title"] == "Matt and Kim"
          concerts << x
        end
      end
    else
      if all_events["title"] == artist
        concerts << all_events
      end
    end
    concerts
  end
end