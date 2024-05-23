# frozen_string_literal: true

class AuthenticationsController < ApplicationController
  include Swagger::Blocks

  swagger_path '/login' do
    operation :post do
      key :description, 'Authenticate user to generate API Key'
      key :produces, [
        'application/json'
      ]
      key :tags, [
        'Authentication'
      ]
      parameter do
        key :name, :body
        key :in, :body
        key :description, 'Authentication object that needs to be sent in the params'
        key :required, true
        schema do
          key :'$ref', :AuthInput
        end
      end
      response 200 do
        key :description, 'pet response'
        schema do
          key :'$ref', :AuthResponse
        end
      end
      response :default do
        key :description, 'unexpected error'
        schema do
          key :'$ref', :ErrorModel
        end
      end
    end
  end

  swagger_schema :AuthInput do
    allOf do
      schema do
        key :required, %i[email password]
        property :email do
          key :type, :string
        end
        property :password do
          key :type, :string
        end
      end
    end
  end
  swagger_schema :AuthResponse do
    allOf do
      schema do
        key :required, %i[email token]
        property :email do
          key :email, :string
        end
        property :token do
          key :type, :string
        end
      end
    end
  end

  def login
    user = User.find_by(email: login_params[:email])
    if user&.authenticate(login_params[:password])
      token = JWT.encode({ user_id: user.id }, ENV.fetch('SECRET_KEY'), 'HS256')
      render json: { user: { id: user.id, email: user.email }, token: token}
    else
      render json: { errors: 'invalid credentials!' }, status: :unprocessable_entity
    end
  end

  def login_params
    params.require(:authentication).permit(:email, :password)
  end
end
