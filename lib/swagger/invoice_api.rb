# frozen_string_literal: true

module Swagger
  module InvoiceApi
    extend ActiveSupport::Concern

    included do
      include Swagger::Blocks

      # Define the /invoices endpoint
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
        operation :get do
          key :summary, 'Retrieve all invoices'
          key :description, 'Returns a list of invoices. Optionally, filter by status.'
          key :operationId, 'getInvoices'
          key :tags, ['Invoice']
          security do
            key :api_key, []
          end

          parameter name: :state do
            key :in, :query
            key :description, 'Filter by invoice status'
            key :required, false
            key :type, :string
          end

          response 200 do
            key :description, 'Invoice object response'
            schema type: :array do
              items do
                key :'$ref', :Invoice
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

      # Define the /invoices/{id}/publish endpoint
      swagger_path '/invoices/{id}/publish' do
        operation :post do
          key :summary, 'Publish an Invoice'
          key :description, 'Publish an invoice'
          key :operationId, 'publishInvoice'
          key :tags, ['Invoice']
          security do
            key :api_key, []
          end
          parameter name: :id do
            key :in, :path
            key :description, 'ID of the invoice to publish'
            key :required, true
            key :type, :integer
          end

          response 200 do
            key :description, 'Invoice published successfully'
            schema do
              key :'$ref', :Invoice
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

      # Define the /invoices/{id}
      swagger_path '/invoices/{id}' do
        operation :get do
          key :summary, 'Retrieve a specific invoice'
          key :description, 'Returns a single invoice by ID'
          key :operationId, 'getInvoiceById'
          key :tags, ['Invoice']
          security do
            key :api_key, []
          end

          parameter name: :id do
            key :in, :path
            key :description, 'ID of the invoice to retrieve'
            key :required, true
            key :type, :integer
            key :format, :int64
          end

          response 200 do
            key :description, 'Invoice details'
            content 'application/json' do
              schema do
                key :'$ref', :Invoice
              end
            end
          end
        end
        operation :put do
          key :summary, 'Update an existing invoice'
          key :description, 'Updates an invoice by ID'
          key :operationId, 'updateInvoice'
          key :tags, ['Invoice']
          security do
            key :api_key, []
          end

          parameter name: :id do
            key :in, :path
            key :description, 'ID of the invoice to update'
            key :required, true
            key :type, :integer
            key :format, :int64
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
                  key :required, [:id, :item_id, :quantity, :_destroy]
                  property :id do
                    key :type, :integer
                  end
                  property :item_id do
                    key :type, :integer
                  end
                  property :quantity do
                    key :type, :integer
                  end
                  property :_destroy do
                    key :type, :boolean
                  end
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

      # Define the Invoice schema
      swagger_schema :Invoice do
        key :required, [:id, :invoice_number, :aasm_state, :due_date, :total_amount, :published_url]

        property :id do
          key :type, :integer
          key :format, :int64
        end
        property :invoice_number do
          key :type, :string
        end
        property :aasm_state do
          key :type, :string
        end
        property :published_url do
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
  end
end
