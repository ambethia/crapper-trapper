Rails.application.routes.draw do
  # Authentication
  get 'sign_out', to: 'sessions#destroy'
  get 'auth/failure', to: redirect('/')
  match 'auth/:provider/callback', to: 'sessions#create', via: %i[get post]

  get 'dashboard', to: 'home#dashboard'

  root 'home#index'
end
