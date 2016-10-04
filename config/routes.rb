require "sidekiq/web"

Rails.application.routes.draw do
  # Rails information is provided by default at:
  #   'localhost:3000/rails/info/properties'

  # Clearance routes.
  resources :passwords, controller: "clearance/passwords", only: [:create, :new]
  resource  :session,   controller: "clearance/sessions",  only: [:create]

  resources :users, controller: "clearance/users", only: [:create] do
    resource :password, controller: "clearance/passwords", only: [:create, :edit, :update]
  end

  get    "log_in"  => "clearance/sessions#new"
  get    "log_in"  => "clearance/sessions#new", as: "sign_in"
  delete "log_out" => "clearance/sessions#destroy"
  get    "sign_up" => "clearance/users#new"

  # Miscellaneous pages.
  root "misc_pages#home"
  get "home"    => "misc_pages#home"
  get "about"   => "misc_pages#about"
  get "details" => "misc_pages#details"

  # Sidekiq management interface.
  mount Sidekiq::Web, at: "/sidekiq"

  # Artist and album routes.
  #
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
