require "google/api_client"
require "google/api_client/client_secrets"
require "figaro" 
require "pry"
 
 
client = Google::APIClient.new(
  application_name: "Demo Calendar Client",
  application_version: "0.0.1"
)

 
#client.authorization = Google::APIClient::ClientSecrets.load.to_authorization
client.authorization.client_id = Figaro.env.google_client_id
client.authorization.client_secret = Figaro.env.google_client_secret
client.authorization.scope = 'https://www.googleapis.com/auth/calendar'
 
client.authorization.access_token = #user_token
client.authorization.refresh_token = #user_refresh_token # Note: you need to ask for "offline" or something similar to get this
client.authorization.issued_at = Time.at(#expires_at - 3600)
client.authorization.expires_in = 3600
 
calendar = client.discovered_api('calendar', 'v3')
 
response = client.execute(
  api_method: calendar.events.list,
  parameters: { 'calendarId' => 'primary'},
  authorization: client.authorization
)
 
list = JSON.parse response.body
 
binding.pry