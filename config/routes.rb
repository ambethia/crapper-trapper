require 'sidekiq/web'

Rails.application.routes.draw do
  # Authentication
  get 'sign_out', to: 'sessions#destroy'
  get 'auth/failure', to: redirect('/')
  match 'auth/:provider/callback', to: 'sessions#create', via: %i[get post]

  get 'dashboard', to: 'home#dashboard'

  resources :senders, only: %i[index create destroy]

  mount Sidekiq::Web => '/sidekiq', :constraints => ->(request) { User.exists?(request.session[:user_id]) }

  root 'home#index'
end
