# frozen_string_literal: true

class InvoicesController < ApplicationController
  include Swagger::InvoiceApi
  # before_action :authenticate_request!
  before_action :set_invoice, only: %i[publish show]

  # POST /invoices
  def create
    @invoice = @user.invoices.build(invoice_params)
    if @invoice.save
      render json: @invoice, status: :created, include: { invoice_items: { include: :item } }
    else
      render json: @invoice.errors, status: :unprocessable_entity
    end
  end

  # POST /invoices/:id/publish
  def publish
    unless @invoice.may_publish?
      raise HandledError::InvalidParamsError,
            "invalid state, cannot publish invoice with state #{@invoice.aasm_state}!"
    end

    response = Xendit::Requests::CreateInvoice.new(@invoice).fire!
    if response.success?
      @invoice.publish!(response.parsed_body[:invoice_url])
      render json: @invoice, status: :ok
    else
      render json: { error: 'unable to publish invoice!', error_details: response.parsed_body },
             status: :unprocessable_entity
    end
  end

  # GET /invoices
  def index
    if params[:state].present?
      unless Invoice.valid_states.include? params[:state].to_sym
        raise HandledError::InvalidParamsError,
              'invalid status!'
      end

      @invoice = Invoice.where(aasm_state: params[:state])
    else
      @invoice = Invoice.all
    end
    render json: @invoice, status: :ok
  end

  # GET /invoices/:id
  def show
    render json: @invoice, status: :ok
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

  def validate_params!
    return unless params[:state].present?
    raise HandledError::InvalidParamsError, 'invalid status!' unless Invoice.valid_states.include? params[:state]
  end
end
