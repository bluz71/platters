Rails.application.routes.draw do
  root "pages#home"

  get "home"    => "pages#home"
  get "details" => "pages#details"
  get "sources" => "pages#sources"

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
