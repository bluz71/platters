Rails.application.routes.draw do
  root "artists#index"

  resources :artists do
    resources :albums, only: [:new, :create, :edit, :update]
  end

  resources :albums, except: [:new, :create, :edit, :update]
end
