# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ExceptionHandler
  def authenticate_request!
    raise HandledError::AuthenticationError, 'invalid token!' unless jwt_encoded?(access_token)
    token = JWT.decode(access_token, ENV.fetch('SECRET_KEY'), true, algorithm: 'HS256')
    user_id = token[0]['user_id']
    @user = User.find(user_id)
    raise HandledError::AuthenticationError, 'invalid user!' unless @user.present?
  end

  def authorization_header
    unless request.headers['Authorization'].present?
      raise HandledError::AuthenticationError,
            'missing authorization header'
    end

    request.headers['Authorization']
  end

  def jwt_encoded?(str)
    str.split('.').count == 3
  end
  def access_token
    authorization_header
  end
end
