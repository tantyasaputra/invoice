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
              key :required, [:invoice_number, :due_date, :invoice_items_attributes]

              property :invoice_number do
                key :type, :string
              end
              property :due_date do
                key :type, :string
                key :format, :date
              end
              property :invoice_items_attributes do
                key :type, :array
                items do
                  key :'$ref', :InvoiceItem
                end
              end
            end
          end
          response 200 do
            key :description, 'Invoice object response'
            schema do
              key :required, [:id, :aasm_state, :invoice_number, :due_date, :total_amount ]

              property :id do
                key :type, :integer
                key :format, :int64
              end
              property :aasm_state do
                key :type, :string
              end
              property :invoice_number do
                key :type, :string
              end
              property :due_date do
                key :type, :string
                key :format, :date
              end
              property :total_amount do
                key :type, :number
                key :format, :double
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
      # Define the InvoiceItem schema
      swagger_schema :InvoiceItem do
        key :required, [:item_id, :quantity]

        property :item_id do
          key :type, :integer
          key :format, :int64
        end

        property :quantity do
          key :type, :integer
          key :format, :int32
        end
      end
    end
  end
end
