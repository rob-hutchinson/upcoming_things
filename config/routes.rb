Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }
  
  root "application#home"

  get "/albums/list" => "albums#list"
  get "/albums/concerts" => "albums#concert"

  post "/albums/:album_id/favorite" => "albums#favorite", as: "favorite_album"
  delete "albums/:album_id/unfavorite" => "albums#unfavorite", as: "unfavorite_album"
end
