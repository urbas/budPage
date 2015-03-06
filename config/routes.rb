Rails.application.routes.draw do

  devise_for :users

  root to: 'pages#home'

  get ':page', to: 'pages#page', as: :pages

end
