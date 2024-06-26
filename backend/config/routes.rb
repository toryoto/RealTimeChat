Rails.application.routes.draw do
  namespace :api, format: :json do
    mount_devise_token_auth_for 'User', at: 'auth', controllers: {
      registrations: 'auth/registrations'
    }

    resources :messages, only: ['index', 'update', 'destroy'] do
      member do
        resources :likes, only: ['create']
      end
    end

    resources :likes, only: ['destroy']

    resources :users, only: ['show'] do 
      member do 
        put 'email_visibility', to: 'users#update_email_visibility'
      end
    end
  end
end