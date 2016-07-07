Rails.application.routes.draw do
  root "artists#index"

  resources :artists do
    resources :albums, except: [:index]
  end

  resources :albums, only: [:index]
end
