Rails.application.routes.draw do
  resources :tags
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  
  root to: "articles#index"
  
  get 'home/index'
  get 'home_controller/index'
  
  resources :articles
  resources :tags
  
end
