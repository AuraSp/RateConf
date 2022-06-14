Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :pdf_api, only: [:create]
      resources :textractor_job, only: [:create]
    end
  end
end
