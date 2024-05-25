# frozen_string_literal: true

module Swagger
  module AuthenticationApi
    extend ActiveSupport::Concern

    included do
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
              key :required, %i[email password]
              property :email do
                key :type, :string
              end
              property :password do
                key :type, :string
              end
            end
          end
          response 200 do
            key :description, 'pet response'
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
          response :default do
            key :description, 'unexpected error'
            schema do
              key :'$ref', :ErrorSchema
            end
          end
        end
      end
    end
  end
end