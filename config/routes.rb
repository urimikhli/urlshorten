Rails.application.routes.draw do
  # no index route, Eventually will redirect to current User urlShortens list.

  post 'login', to: 'access_tokens#create'
  resources :shortens, only: %i[show index create update destroy], param: :slug
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
