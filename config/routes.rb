Rails.application.routes.draw do
    get 'ask/index'
    get 'login', to: 'login#new'
    get 'login/profile', to: 'login#profile', as: :profile_login
    post 'login/profile', to: 'login#update', as: :update_login
    get 'login/create', to: 'login#create', as: :create_login
    get 'login/delete', to: 'login#delete', as: :delete_login
    get 'threads' => 'comments#threads'
      
    resources :submissions
    resources :posts do
      resources :likes and
      put 'like', on: :member and
      put 'unlike', on: :member and
      post 'comment', on: :member and
      resources :comments
    end
    
    resources :comments do
      post 'comment', on: :member and
      resources :comments 
      resources :commentlikes
    end
    root 'posts#index'
end
