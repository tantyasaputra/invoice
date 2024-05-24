# frozen_string_literal: true

module Xendit
  module Requests
    class CreateInvoice
      def initialize(invoice)
        @invoice_number = invoice.invoice_number
        @total_amount = invoice.total_amount
        @due_date = invoice.due_date
      end

      def target_url
        'https://api.xendit.co/v2/invoices'
      end

      def api_method
        :post
      end

      def headers
        {
          'Content-Type' => 'application/json',
          'Authorization' => generate_api_key
        }
      end

      def invoice_duration
        (@due_date.to_time.in_time_zone - DateTime.now.in_time_zone('Asia/Jakarta')).to_i
      end

      def json_body
        {
          external_id: @invoice_number,
          amount: @total_amount,
          invoice_duration:,
          currency: 'IDR'
        }.to_json
      end

      def response_class
        Xendit::Responses::Base
      end

      def fire!
        response = HTTParty.send(
          :post,
          target_url,
          headers:,
          body: json_body
        )

        response_class.new(response)
      end

      private

      def generate_api_key
        api_key = Base64.encode64("#{ENV.fetch('XENDIT_SECRET_KEY')}:").gsub(/\n/, '')
        "Basic #{api_key}"
      end
    end
  end
end
