Rails.application.routes.draw do
  get 'posts/newest', to: 'posts#newest'
  resources :submissions
  resources :posts do
    put 'like', on: :member and
    put 'unlike', on: :member
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'posts#index'
  
end
