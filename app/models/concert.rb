class Concert

  def search artists, zipcode
    concerts = []
    data = []

    artist_query = artists.map { |x| x.split(" ").join("+") }
    
    artist_query.each do |x|
      data << HTTParty.get("http://api.eventful.com/rest/events/search?category=music&
      sort_order=date&location=#{zipcode}&within=25&date=future&page_size=100
      &keywords=#{x}", query: {"app_key"=> Figaro.env.eventful_key})
    end

    all_events = data.map {|x| if x["search"]["total_items"].to_i > 0 
      then x["search"]["events"]["event"] end }.compact
    
      all_events.each do |x|
        if x.class == Hash
          if artists.include?(x["title"])
            concerts << x
          end
        else
          x.each do |y|
            if artists.include?(y["title"])
              concerts << y
            end
          end
        end
      end
      
    concerts
  end

end