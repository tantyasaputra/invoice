# frozen_string_literal: true

module Swagger
  module InvoiceApi
    extend ActiveSupport::Concern

    included do
      include Swagger::Blocks

      swagger_path '/invoices' do
        operation :post do
          key :summary, 'Create an Invoice'
          key :description, 'Use this endpoint to create an Invoice'
          key :produces, [
            'application/json'
          ]
          key :tags, [
            'Invoice'
          ]
          security do
            key :api_key, []
          end
          parameter do
            key :name, :body
            key :in, :body
            key :description, 'Invoice object that needs to be sent in the params'
            key :required, true
            schema do
              key :'$ref', :ItemInput
            end
          end
          response 200 do
            key :description, 'item response'
            schema do
              key :type, :array
              items do
                key :'$ref', :Item
              end
            end
          end
          response :default do
            key :description, 'error'
            schema do
              key :'$ref', :ErrorSchema
            end
          end
        end
      end
    end
  end
end
