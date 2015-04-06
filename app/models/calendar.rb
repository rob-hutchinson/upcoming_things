require "google/api_client"
require "google/api_client/client_secrets"
require "figaro" 
require "pry"

  class Calendar 
    
    def get_list user
      client = Google::APIClient.new(
        application_name: "Demo Calendar Client",
        application_version: "0.0.1"
      )

      # client.authorization = Google::APIClient::ClientSecrets.load.to_authorization
      client.authorization.client_id = Figaro.env.google_client_id
      client.authorization.client_secret = Figaro.env.google_secret
      client.authorization.scope = 'https://www.googleapis.com/auth/calendar'

      client.authorization.access_token = user.user_token#user_token
      client.authorization.refresh_token = user.user_refresh_token#user_refresh_token # Note: you need to ask for "offline" or something similar to get this
      client.authorization.issued_at = Time.at(user.token_refreshes_at - 3600)
      client.authorization.expires_in = 3600
      
      calendar = client.discovered_api('calendar', 'v3')
      
      record = Album.find(48)

      response = client.execute(
        api_method: calendar.events.list,
        parameters: { 'calendarId' => 'primary', 'q' => "#{record.artist}"},
        authorization: client.authorization
      )
       
      list = JSON.parse response.body

    binding.pry
    end

    def add_event user, album
      client = Google::APIClient.new(
        application_name: "Demo Calendar Client",
        application_version: "0.0.1"
      )

      # client.authorization = Google::APIClient::ClientSecrets.load.to_authorization
      client.authorization.client_id = Figaro.env.google_client_id
      client.authorization.client_secret = Figaro.env.google_secret
      client.authorization.scope = 'https://www.googleapis.com/auth/calendar'

      client.authorization.access_token = user.user_token#user_token
      client.authorization.refresh_token = user.user_refresh_token#user_refresh_token # Note: you need to ask for "offline" or something similar to get this
      client.authorization.issued_at = Time.at(user.token_refreshes_at - 3600)
      client.authorization.expires_in = 3600
      
      calendar = client.discovered_api('calendar', 'v3')
      id_code = Favorite.find_by(user_id: user.id, album_id: album.id).id_code
      # response = client.execute(
      #   api_method: calendar.events.list,
      #   parameters: { 'calendarId' => 'primary'},
      #   authorization: client.authorization
      # )
       
      # list = JSON.parse response.body

      event = {
        'summary' => "'#{album.album_title}' ~ #{album.artist} release date",
        'start' => {'date' => "#{album.release_date}"},
        'end' => {'date' => "#{album.release_date}"},
        'description' => 'CD releases today!',
        'id' => "#{id_code}"
        }

      result = client.execute(
            :api_method => calendar.events.insert,
            :parameters => {'calendarId' => 'primary'},
            :body => JSON.dump(event),
            :headers => {'Content-Type' => 'application/json'})
    end

    def delete_event user, event_id
      client = Google::APIClient.new(
        application_name: "Demo Calendar Client",
        application_version: "0.0.1"
      )

      # client.authorization = Google::APIClient::ClientSecrets.load.to_authorization
      client.authorization.client_id = Figaro.env.google_client_id
      client.authorization.client_secret = Figaro.env.google_secret
      client.authorization.scope = 'https://www.googleapis.com/auth/calendar'

      client.authorization.access_token = user.user_token#user_token
      client.authorization.refresh_token = user.user_refresh_token#user_refresh_token # Note: you need to ask for "offline" or something similar to get this
      client.authorization.issued_at = Time.at(user.token_refreshes_at - 3600)
      client.authorization.expires_in = 3600
      
      calendar = client.discovered_api('calendar', 'v3')

     result = client.execute(
            :api_method => calendar.events.delete,
            :parameters => {'calendarId' => 'primary', 'eventId' => "#{event_id}"})
    end
  end