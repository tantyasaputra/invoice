# frozen_string_literal: true

class InvoicesController < ApplicationController
  include Swagger::InvoiceApi
  before_action :authenticate_request!
  before_action :set_invoice, only: %i[publish]

  # POST /invoices
  def create
    @invoice = @user.invoices.build(invoice_params)
    if @invoice.save
      render json: @invoice, status: :created, include: { invoice_items: { include: :item } }
    else
      render json: @invoice.errors, status: :unprocessable_entity
    end
  end

  def publish
    response = Xendit::Requests::CreateInvoice.new(@invoice).fire!
    if response.success? && @invoice.may_publish?
      invoice_url = response.parsed_body[:invoice_url]
      @invoice.publish!(invoice_url)
      render json: @invoice, status: :ok
    else
      render json: { error: 'unable to publish invoice!', error_details: response.parsed_body }, status: :unprocessable_entity
    end
  end

  private

  def invoice_params
    params.require(:invoice).permit(:user_id, :invoice_number, :due_date,
                                    invoice_items_attributes: %i[item_id quantity])
  end

  def set_invoice
    @invoice = Invoice.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'invoice not found' }, status: :not_found
  end
end
