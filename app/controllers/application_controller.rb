# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Helpers::ErrorHandler
  def authenticate_request!
    token = JWT.decode(access_token, ENV.fetch('SECRET_KEY'), true, algorithm: 'HS256')
    user_id = token[0]['user_id']
    @user = User.find(user_id)
    raise HandledError::AuthenticationError, "invalid user" unless @user.present?
  end

  def authorization_header
    raise HandledError::AuthenticationError, "missing authorization header" unless request.headers["Authorization"].present?
    request.headers["Authorization"]
  end

  def access_token
    authorization_header
  end
end
