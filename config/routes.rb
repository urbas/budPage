Rails.application.routes.draw do
  devise_for :users
  root to: 'application#home'

  resources :responses do
      get :family
  end

end
