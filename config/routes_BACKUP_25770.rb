Rails.application.routes.draw do
  get 'posts/newest', to: 'posts#newest'
  resources :submissions
  resources :posts
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'posts#index'
<<<<<<< HEAD
=======
  
>>>>>>> new_page
end
