Rails.application.routes.draw do
  resources :sequences, except: [:destroy, :edit, :update]
  resources :settings
  resources :loans
  resources :books do
    get 'clone', on: :collection
  end
  resources :users
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'welcome', to: 'sessions#welcome'
  delete 'logout', to: 'sessions#logout'
  root 'sessions#welcome'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
