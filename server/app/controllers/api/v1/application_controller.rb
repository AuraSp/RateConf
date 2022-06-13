class ApplicationController < ActionController::Base
  # begin
  TOKEN = "Test"

  before_action :authenticate

  private

  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      ActiveSupport::SecurityUtils.secure_compare(token, TOKEN)
      # return if Resource.find_by(
      #   key: key,
      #   secret: secret,
      # )

      # render(
      #   json: 'Invalid credentials'.to_json,
      #   status: 401,
      #   ContactMailer.authorization_succesful().deliver_later
      # )
    end
  end

  # FOR BASIC AUTHENTICATION
  # def authenticate()
  #   authenticate_or_request_with_http_basic do |username, password|
  #     username == "username" && password == "password"
  #   end
  # end

  # rescue Exception => auth
  #   render json: { status: "FAILURE", data: "Unauthorized activity" }, status: 401
  # end
end
