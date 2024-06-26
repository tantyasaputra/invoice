# frozen_string_literal: true

class SwaggersController < ActionController::Base
  include Swagger::Blocks

  swagger_root do
    key :swagger, '2.0'
    info do
      key :version, '1.0.0'
      key :title, 'Invoice API Documentation'
      key :description, 'API Documentation for Invoice APPs'
      contact do
        key :name, 'Invoice API Team'
      end
      license do
        key :name, 'MIT'
      end
    end
    security_definition :api_key do
      key :type, :apiKey
      key :name, :Authorization
      key :in, :header
    end

    # key :host, 'petstore.swagger.wordnik.com'
    # key :basePath, '/api'
    key :consumes, ['application/json']
    key :produces, ['application/json']
  end

  swagger_schema :ErrorSchema do
    key :required, %i[error]
    property :error do
      key :type, :string
    end
  end

  # A list of all classes that have swagger_* declarations.
  SWAGGERED_CLASSES = [
    AuthenticationsController,
    ItemsController,
    InvoicesController,
    self
  ].freeze

  def index
    render json: Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
  end
end
