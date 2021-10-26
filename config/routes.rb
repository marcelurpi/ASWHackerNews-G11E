Rails.application.routes.draw do
    get 'posts/newest', to: 'posts#newest'
    resources :submissions
    resources :posts
    root 'posts#index'
end
