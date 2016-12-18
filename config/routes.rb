# frozen_string_literal: true

require "sidekiq/web"

Rails.application.routes.draw do
  # Rails information is provided by default at:
  #   localhost:3000/rails/info/properties

  # UserMailer email preview, in development mode, is provided at:
  #   localhost:3000/rails/mailers/user_mailer

  # CLEARANCE ROUTES
  resources :passwords, controller: "clearance/passwords", only: [:create, :new]
  resource  :session,   controller: "sessions",  only: [:create]
  resources :users, controller: "users", only: [:create] do
    resource :password, controller: "passwords", only: [:create, :edit, :update]
  end

  resources :users, only: [:update, :destroy]
  # Setup custom "edit_user" path specifically without "edit" in the URL which
  # is usually needed to differentiate between show and edit pages, in this
  # case there will be no show user page so "edit" path value is not needed.
  get "/users/:id" => "users#edit", as: "edit_user"

  # The Clearance authentication gem by default does not provide email
  # confirmation. This thoughtbot article details how to add email confirmation
  # to Clearance:
  #   https://robots.thoughtbot.com/email-confirmation-with-clearance
  #
  # Setup a custom "confirm_email" path to validate that a newly signed-up user
  # actually is the owner of the specified email address. A confirmation link
  # (sent from UsersController#create via UserMailer#email_confirmation) will
  # be the following route which will contain both user's name and unique
  # confirmation token.
  get "/confirm_email/:name/:token" => "email_confirmations#update", as: "confirm_email"

  get    "log_in"     => "clearance/sessions#new"
  get    "log_in"     => "clearance/sessions#new", as: "sign_in"
  delete "log_out"    => "clearance/sessions#destroy"
  get    "sign_up"    => "clearance/users#new"

  # MISCELLANEOUS ROUTES
  root "misc_pages#home"
  get "home"    => "misc_pages#home"
  get "about"   => "misc_pages#about"
  get "details" => "misc_pages#details"

  # SIDEKIQ MANAGEMENT INTERFACE
  constraints Clearance::Constraints::SignedIn.new { |user| user.admin? } do
    mount Sidekiq::Web, at: "/sidekiq"
  end

  # ARTIST AND ALBUM ROUTES
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

  resources :artists, path: "", except: [:index, :new, :create] do
    resources :comments, module: :artists, only: [:create, :destroy]
  end

  resources :artists, path: "", only: [] do
    resources :albums, path: "", except: :index do
      resources :comments, module: :albums, only: [:create, :destroy]
    end
  end
end
