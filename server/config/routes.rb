Rails.application.routes.draw do
  resources :pdf_api, only: [:create]
end
