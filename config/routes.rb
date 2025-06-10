Rails.application.routes.draw do
  namespace :api do
    resources :contacts, param: :id, only: [:index, :show, :create, :destroy]
  end
end