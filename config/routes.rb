Rails.application.routes.draw do
  root "artists#index"

  resources :artists do
    resources :albums, except: [:index, :destroy]
  end

  resources :albums, only: [:index, :destroy]
end
