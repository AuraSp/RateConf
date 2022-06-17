require 'sidekiq/web'
Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq" # mount Sidekiq::Web in your Rails app
  namespace :api do
    namespace :v1 do
      resources :pdf_api, only: [:create]
      resources :textractor_job, only: [:create]
      resources :pdf_api do
        collection do
          get 'view'
        end
      end
  end
end
end