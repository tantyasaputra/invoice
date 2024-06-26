# frozen_string_literal: true

module Swagger
  module ItemsApi
    extend ActiveSupport::Concern

    included do
      include Swagger::Blocks

      swagger_path '/items' do
        operation :get do
          key :summary, 'Fetches all Item'
          key :description, 'Returns all items from the system that the user has access to'
          key :produces, [
            'application/json'
          ]
          key :tags, [
            'Items'
          ]
          security do
            key :api_key, []
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
        end

        operation :post do
          key :description, "Creates a new items. Item's name must be uniq"
          key :produces, [
            'application/json'
          ]
          key :tags, [
            'Items'
          ]
          security do
            key :api_key, []
          end
          parameter do
            key :name, :body
            key :in, :body
            key :description, 'Item object that needs to be sent in the params'
            key :required, true
            schema do
              key :'$ref', :Item
            end
          end
          response 200 do
            key :description, 'Item response'
            schema do
              key :'$ref', :Item
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
      swagger_schema :Item do
        key :required, %i[id name unit_price]
        property :id do
          key :type, :integer
          key :format, :int64
        end
        property :name do
          key :type, :string
        end
        property :description do
          key :type, :string
        end
        property :unit_price do
          key :type, :number
          key :format, :double
        end
      end
    end
  end
end
