Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'filters#index'
  get '/filters/location' => 'filters#location'
  resources :filters
  
end
