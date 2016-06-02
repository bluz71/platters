Rails.application.routes.draw do
  root "artists#index"

  resources :artists do
    resources :albums, only: [:new, :create]
  end

  resources :albums, only: [:index, :show]
end
