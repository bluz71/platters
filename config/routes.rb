Rails.application.routes.draw do
  root "artists#index"

  resources :artists
end
