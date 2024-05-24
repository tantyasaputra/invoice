# frozen_string_literal: true

module Xendit
  module Responses
    class Base
      attr_reader :http_response

      def initialize(http_response)
        @http_response =
          case http_response
          when Hash
            OpenStruct.new(http_response)
          when StandardError, Exception
            OpenStruct.new(code: nil, body: "#{http_response.class}: #{http_response.message}")
          else
            http_response
          end
      end

      def http_code
        @http_response.try(:code)
      end

      def http_headers
        @http_response.try(:headers)
      end

      def http_body
        @http_response.try(:body)
      end

      def parsed_body
        @parsed_body ||=
          case http_body
          when String
            JSON.parse(http_body, object_class: HashWithIndifferentAccess) || {}
          when Hash
            HashWithIndifferentAccess.new(http_body)
          else
            {}
          end
      end

      def timeout?
        http_code.to_s == Rack::Utils.status_code(:gateway_timeout).to_s
      end

      def success?
        http_response && http_response.code >= 200 && http_response.code < 300
      end
    end
  end
end
