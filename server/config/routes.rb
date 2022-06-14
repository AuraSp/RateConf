Rails.application.routes.draw do
  resources :pdf_api, only: [:view, :create]
  resources :pdf_api do
    collection do
      get 'view'
    end
  end
end
