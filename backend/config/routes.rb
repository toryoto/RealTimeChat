Rails.application.routes.draw do
  namespace :api, format: :json do
    mount_devise_token_auth_for 'User', at: 'auth', controllers: {
      registrations: 'api/auth/registrations'
    }

    resources :messages, only: ['index', 'update', 'destroy'] do
      member do
        resources :likes, only: ['create']
      end
    end

    resources :likes, only: ['destroy']

    resources :users, only: ['show']
  end
end