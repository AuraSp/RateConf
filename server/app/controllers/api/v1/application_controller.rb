class ApplicationController < ActionController::Base
  TOKEN = "Test"

  before_action :authenticate
  protect_from_forgery with: :null_session

  private

  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      ActiveSupport::SecurityUtils.secure_compare(token, TOKEN)
    end
  end
end
