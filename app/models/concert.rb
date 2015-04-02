class Concert

  def search artist, zipcode
    concerts = []
    artist_query = artist.split(" ").join("+")
    
    data = HTTParty.get("http://api.eventful.com/rest/events/search?category=music&
    sort_order=date&location=#{zipcode}&within=25&date=future&page_size=100
    &keywords=#{artist_query}", query: {"app_key"=> Figaro.env.eventful_key})
    
    if data["search"]["total_items"].to_i == 1
      all_events = [] << data["search"]["events"]["event"]
    else
      all_events = data["search"]["events"]["event"]
    end
      
    all_events.each do |x|
      if x["title"] == artist || x["title"] == "Matt and Kim"
        concerts << x
      end
    end
    concerts
  end

end