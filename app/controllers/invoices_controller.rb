# frozen_string_literal: true

class InvoicesController < ApplicationController
  include Swagger::InvoiceApi
  before_action :authenticate_request!

  # POST /invoices
  def create
    @invoice = @user.invoices.build(invoice_params)

    if @invoice.save
      render json: @invoice, status: :created, include: { invoice_items: { include: :item } }
    else
      render json: @invoice.errors, status: :unprocessable_entity
    end
  end

  private

  def invoice_params
    params.require(:invoice).permit(:user_id, :invoice_number, :due_date, invoice_items_attributes: %i[item_id quantity])
  end
end
