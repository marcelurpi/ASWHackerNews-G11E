Rails.application.routes.draw do
  get 'ask/index'
    get 'login', to: 'login#new'
    get 'login/create', to: 'login#create', as: :create_login
    get 'login/delete', to: 'login#delete', as: :delete_login
    get 'posts/newest', to: 'posts#newest'
    get 'posts/ask', to: 'posts#ask'
    resources :submissions
    resources :posts
    root 'posts#index'
end
