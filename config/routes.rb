Rails.application.routes.draw do
  # no index route, Eventually will redirect to current User urlShortens list.
  resources :shortens, only: %i[index show create update destroy], param: :slug
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
