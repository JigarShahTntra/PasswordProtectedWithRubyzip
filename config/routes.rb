Rails.application.routes.draw do
  get 'contents/create'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :contents, only: [:index, :new, :create]
  root to: 'contents#index'
end
