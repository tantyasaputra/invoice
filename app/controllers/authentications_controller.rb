# frozen_string_literal: true

class AuthenticationsController < ApplicationController
  include Swagger::AuthenticationApi


  def login
    user = User.find_by(email: login_params[:email])
    if user&.authenticate(login_params[:password])
      token = JWT.encode({ user_id: user.id }, ENV.fetch('SECRET_KEY'), 'HS256')
      render json: { user: { id: user.id, email: user.email }, token: }
    else
      render json: { errors: 'invalid credentials!' }, status: :unprocessable_entity
    end
  end

  def login_params
    params.require(:authentication).permit(:email, :password)
  end
end
