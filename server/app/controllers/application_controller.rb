class ApplicationController < ActionController::Base
  include ApiKeyAuthenticatable 
  
  prepend_before_action :authenticate_with_api_key!


  def destroy
    api_key = current_bearer.api_keys.find(params[:id]) 
    api_key.destroy 
  end
end
