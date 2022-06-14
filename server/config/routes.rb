Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :pdf_api, only: [:create]
      resources :textractor_job, only: [:create]
      resources :pdf_api do
        collection do
          get 'view'
    end
    namespace :v2 do
      get "pdfapi/index"
      resources :pdf_api, only: [:create]
    end
  end
end

# require "api_constraints"

# Rails.application.routes.draw do
#   namespace :api do
#     scope module: :v1, constraints: ApiConstraints.new(version: 1) do
#       get "pdfapi/index"
#       # resources :pdfapi
#     end
#     # scope module: :v2, constraints: ApiConstraints.new(version: 2), path: "/" do
#     #   get "pdfapi/index"
#     #   # resources :pdfapi
#     # end
#     # scope module: :v3, constraints: ApiConstraints.new(version: 3), path: "/" do
#     #   get "pdfapi/index"
#     #   # resources :pdfapi
#     # end
#   end

# end
