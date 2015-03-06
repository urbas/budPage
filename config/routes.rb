Rails.application.routes.draw do

  devise_for :users

  root to: 'application#home'

  get ':page', to: 'pages#page', as: :pages

end
