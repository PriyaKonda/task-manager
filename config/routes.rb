Rails.application.routes.draw do

  root "sessions#new"

  get "/signup", to: "users#new", as: :signup
  resources :users, only: [:create]
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  
  resources :tasks
  
  # get '/ably/token', to: 'ably#token'
  
  get "up" => "rails/health#show", as: :rails_health_check
  # if Rails.env.development?
  #   mount LetterOpenerWeb::Engine, at: "/letter_opener"
  # end
end
