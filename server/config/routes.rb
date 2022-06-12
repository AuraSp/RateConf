Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get "pdfapi/index"
    end
    namespace :v2 do
      get "pdfapi/index"
    end
  end

  get "pdfapi/index"
end

# require "api_constraints"

# Rails.application.routes.draw do
#   namespace :api do
#     scope module: :v1, constraints: ApiConstraints.new(version: 1) do
#       get "pdfapi/index"
#     end
#     namespace :api do
#       scope module: :v2, constraints: ApiConstraints.new(version: 2, default: true) do
#         get "pdfapi/index"
#       end
#     end
#   end

#   # get "pdfapi/index"
# end
