class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

protected

  def http_basic_authenticate
    authenticate_or_request_with_http_basic do |username, password|
      [username, password] == [Rails.configuration.http_authentication[:username], Rails.configuration.http_authentication[:password]]
    end
  end
end
