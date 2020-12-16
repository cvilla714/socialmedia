Rails.application.routes.draw do
  root 'posts#index'

  # devise_for :users
  devise_for :users, path: '', path_names: { sign_up: 'register', sign_in: 'login', sign_out: 'logout' }

  resources :users, only: %i[index show]
  resources :friendships, only: %i[index create destroy update]
  resources :posts, only: %i[index create] do
    resources :comments, only: [:create]
    resources :likes, only: %i[create destroy]
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end