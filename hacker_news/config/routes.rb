Rails.application.routes.draw do
    get 'login', to: 'login#new'
    get 'login/create', to: 'login#create', as: :create_login
    get 'login/delete', to: 'login#delete', as: :delete_login
    get 'posts/newest', to: 'posts#newest'
    resources :submissions
    resources :posts
    root 'posts#index'
end
