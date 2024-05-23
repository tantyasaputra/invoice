# frozen_string_literal: true

class AuthenticationsController < ApplicationController
  def login
    user = User.find_by(email: login_params[:username])
    if user && user.authenticate(login_params[:password])
      token = JWT.encode({user_id: user.id}, ENV.fetch('SECRET'), 'HS256')
      render json: {user: { id: user.id, email: user.email }, token: token}
    else
      render json: {errors: user.errors.full_messages}
    end
  end

  def login_params
    params.permit(:email, :password)
  end
end