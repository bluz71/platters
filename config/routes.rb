require "sidekiq/web"

Rails.application.routes.draw do
  # Rails information is provided by default at:
  #   'localhost:3000/rails/info/properties'

  root "misc_pages#home"

  get "home"    => "misc_pages#home"
  get "about"   => "misc_pages#about"
  get "details" => "misc_pages#details"

  mount Sidekiq::Web, at: "/sidekiq"

  # Nested resources, Artist and Album, both using FriendlyId with blank
  # controller names.
  # 
  # Important, read the following, especially the "small problem" section:
  #   http://jasoncodes.com/posts/rails-3-nested-resource-slugs

  resources :genres, only: :create

  resources :artists, only: [:index, :new, :create] do
    member do
      get :albums
    end
  end
  resources :albums, only: :index

  resources :artists, path: "", except: [:index, :new, :create]

  resources :artists, path: "", only: [] do
    resources :albums, path: "", except: :index
  end

end
