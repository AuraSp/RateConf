Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :autofill
    end
  end
  
  get 'pdf/index'
end
