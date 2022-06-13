Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get "pdfapi/index"
    end
    namespace :v2 do
      get "pdfapi/index"
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
