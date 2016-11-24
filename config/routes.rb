Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "welcome#index"

  get "/honestbee/login" => "honestbee#login"
  get "honestbee/code" => "honestbee#code"

  # Use this as redirect uri in production and change the method to get
  post "/honestbee/token" => "honestbee#token"
end
