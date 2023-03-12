Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/candidates', to: 'candidates#index'
  get '/download_csv', to: 'candidates#download_csv', as: 'download_csv'
end
