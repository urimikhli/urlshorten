Rails.application.routes.draw do
  resources :shortens, only: %i[show], param: :slug
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
