Rails.application.routes.draw do

  get 'login', to: 'login#new'
  get 'login/create', to: 'login#create', as: :create_login
  get 'login/delete', to: 'login#delete', as: :delete_login
  get 'posts/newest', to: 'posts#newest'
  resources :submissions
  resources :posts do
    put 'like', on: :member and
    put 'unlike', on: :member
  end
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'posts#index'

end
