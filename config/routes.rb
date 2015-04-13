Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }
  
  root "application#home"

  get "/albums/list" => "albums#list", as: "albums_list"
  get "/albums/concerts" => "albums#concert", as: "concerts"
  post "/albums/concerts/add" => "albums#add_concert", as: "add_concert"

  post "/albums/:album_id/favorite" => "albums#favorite", as: "favorite_album"
  delete "/albums/:album_id/unfavorite" => "albums#unfavorite", as: "unfavorite_album"

  post "/zip/update" => "zip#update", as: 'zip_edit'

end
