class ApplicationController < ActionController::Base
  TOKEN = "Test"

  private

  # def authenticate
  #   authenticate_with_http_token do |token, options|
  #     false
  #     # ActiveSupport::SecurityUtils.secure_compare(token, TOKEN)
  #   end
  # end

    def authenticate()
    authenticate_or_request_with_http_basic do |username, password|
      username == 'username' && password == 'password'
    end
  end

end
