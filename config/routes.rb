Rails.application.routes.draw do
  root to: 'pages#home'
  get ':page', to: 'pages#page', as: :pages, page: /.+/
end
