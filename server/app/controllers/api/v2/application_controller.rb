class ApplicationController < ActionController::Base
  # TOKEN = "Test"

  # before_action :authenticate

  # private

  # def authenticate
  #   authenticate_or_request_with_http_token do |token, options|
  #     ActiveSupport::SecurityUtils.secure_compare(token, TOKEN)
  #     ContactMailer.authorization_succesful().deliver_later
  #   end
  # end

  # FOR BASIC AUTHENTICATION
  #   def authenticate()
  #   authenticate_or_request_with_http_basic do |username, password|
  #     username == 'username' && password == 'password'
  #   end
  # end

end
