Rails.application.routes.draw do
  
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }

  root "application#home"

  get "/albums/list" => "albums#list", as: "albums_list"
  get "/albums/concerts" => "albums#concert", as: "concerts"
  post "/albums/concerts/add" => "albums#add_concert", as: "add_concert"

  post "/albums/:album_id/favorite" => "albums#favorite", as: "favorite_album"
  delete "/albums/:album_id/unfavorite" => "albums#unfavorite", as: "unfavorite_album"

  post "/zip/update" => "zip#update", as: 'zip_edit'

  match '/404', to: 'errors#file_not_found', via: :all
  match '/422', to: 'errors#unprocessable', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all

  get 'errors/file_not_found'
  get 'errors/unprocessable'
  get 'errors/internal_server_error'

end
