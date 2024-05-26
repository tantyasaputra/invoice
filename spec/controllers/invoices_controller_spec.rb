# frozen_string_literal: true

# spec/controllers/invoices_controller_spec.rb

require 'rails_helper'

RSpec.describe InvoicesController, type: :controller do
  let(:user) { create(:user) }
  let(:token) { JWT.encode({ user_id: user.id }, ENV.fetch('SECRET_KEY'), 'HS256') }
  let(:headers) { { 'Authorization' => token.to_s } }
  let(:valid_attributes) do
    {
      user_id: user.id,
      invoice_number: 'INV-1001',
      due_date: '2024-12-31',
      invoice_items_attributes: [{ item_id: item.id, quantity: 5 }]
    }
  end
  let(:item) { create(:item) }
  let(:invalid_attributes) { { invoice_number: '' } }
  let(:invoice) { create(:invoice, user:) }

  before do
    request.headers.merge!(headers)
  end

  describe 'GET #index' do
    context 'without state param' do
      before do
        create_list(:invoice, 3, user:)
      end

      it 'returns a success response' do
        get :index
        expect(response).to be_successful

        json_response = JSON.parse(response.body)
        expect(json_response.length).to eq(3)
        expect(json_response).to all(include('id', 'invoice_number', 'due_date', 'aasm_state', 'total_amount',
                                             'published_url'))
      end
    end

    context 'with valid state param' do
      it 'returns invoices with the specified state' do
        states = %w[created published]

        states.each do |state|
          create(:invoice, user:, aasm_state: state)

          get :index, params: { state: }
          expect(response).to be_successful
          expect(response.content_type).to eq('application/json; charset=utf-8')

          json_response = JSON.parse(response.body)
          expect(json_response.length).to eq(1) # assuming there's one invoice per state
          expect(json_response.first['aasm_state']).to eq(state)
        end
      end
    end

    context 'with invalid state param' do
      it 'returns an error response' do
        get :index, params: { state: 'invalid_state' }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')

        json_response = JSON.parse(response.body)
        expect(json_response).to include('error' => 'invalid status!')
      end
    end
  end

  describe 'GET #show' do
    context 'with valid id' do
      it 'returns a success response' do
        get :show, params: { id: invoice.to_param }
        expect(response).to be_successful

        json_response = JSON.parse(response.body)
        expect(json_response['id']).to eq(invoice.id)
        expect(json_response['invoice_number']).to eq(invoice.invoice_number)
        expect(json_response['due_date']).to eq(invoice.due_date.strftime('%Y-%m-%d'))
        expect(json_response['aasm_state']).to eq(invoice.aasm_state)
        expect(json_response['invoice_items']).to eq([])
      end
    end

    context 'with invalid id' do
      it 'returns a not found response' do
        get :show, params: { id: 'invalid_id' }

        expect(response).to have_http_status(:not_found)
        expect(response.content_type).to eq('application/json; charset=utf-8')

        json_response = JSON.parse(response.body)
        expect(json_response).to include('error' => 'invoice not found')
      end
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Invoice' do
        expect do
          post :create, params: { invoice: valid_attributes }
        end.to change(Invoice, :count).by(1)
                                      .and change(InvoiceItem, :count).by(1)
      end

      it 'renders a JSON response with the new invoice' do
        post :create, params: { invoice: valid_attributes }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json; charset=utf-8')

        json_response = JSON.parse(response.body)
        expect(json_response['invoice_number']).to eq('INV-1001')
        expect(json_response['due_date']).to eq('2024-12-31')
        expect(json_response['total_amount']).to eq('3995.0')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new invoice' do
        post :create, params: { invoice: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        {
          invoice_number: 'INV-1002',
          due_date: '2024-6-30'
        }
      end

      it 'updates the requested invoice' do
        put :update, params: { id: invoice.to_param, invoice: new_attributes }
        invoice.reload
        expect(invoice.invoice_number).to eq('INV-1002')
        expect(invoice.due_date.to_s).to eq('2024-06-30')
      end

      it 'renders a JSON response with the invoice' do
        put :update, params: { id: invoice.to_param, invoice: new_attributes }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        json_response = JSON.parse(response.body)
        expect(json_response['invoice_number']).to eq('INV-1002')
        expect(json_response['due_date']).to eq('2024-06-30')
      end
    end

    context 'with new invoice_item_attributes params' do
      let(:new_attributes) do
        {
          invoice_number: 'INV-5678',
          due_date: '2024-12-31',
          invoice_items_attributes: [
            { item_id: item.id, quantity: 5 }
          ]
        }
      end
      it 'updates the requested invoice and its invoice items' do
        put :update, params: { id: invoice.to_param, invoice: new_attributes }

        expect(response).to be_successful
        expect(response.content_type).to eq('application/json; charset=utf-8')

        invoice.reload
        json_response = JSON.parse(response.body)

        expect(invoice.invoice_number).to eq('INV-5678')
        expect(invoice.invoice_items.size).to eq(1)
        expect(invoice.due_date.strftime('%Y-%m-%d')).to eq('2024-12-31')
        expect(json_response['invoice_number']).to eq('INV-5678')
        expect(json_response['due_date']).to eq('2024-12-31')
        expect(json_response['total_amount']).to eq('3995.0')
      end
    end

    context 'with remove invoice_item_attributes params' do
      let(:invoice) { create(:invoice, user:) }
      let!(:existing_invoice_item) { create(:invoice_item, invoice:, item:, quantity: 1) }
      let(:new_attributes) do
        {
          invoice_number: 'INV-5678',
          due_date: '2024-12-31',
          invoice_items_attributes: [
            { id: existing_invoice_item.id, _destroy: true }
          ]
        }
      end
      it 'updates the requested invoice and its invoice items' do
        invoice.update_total_amount
        put :update, params: { id: invoice.to_param, invoice: new_attributes }

        expect(response).to be_successful
        expect(response.content_type).to eq('application/json; charset=utf-8')

        invoice.reload
        json_response = JSON.parse(response.body)

        expect(invoice.invoice_number).to eq('INV-5678')
        expect(invoice.invoice_items.size).to eq(0)
        expect(invoice.due_date.strftime('%Y-%m-%d')).to eq('2024-12-31')
        expect(json_response['invoice_number']).to eq('INV-5678')
        expect(json_response['due_date']).to eq('2024-12-31')
        expect(json_response['total_amount']).to eq('0.0')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the invoice' do
        put :update, params: { id: invoice.to_param, invoice: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe 'POST #publish' do
    it 'publishes the invoice' do
      allow_any_instance_of(Xendit::Requests::CreateInvoice).to receive(:fire!).and_return(double('Response',
                                                                                                  success?: true, parsed_body: { invoice_url: 'http://example.com' }))
      post :publish, params: { id: invoice.to_param }
      invoice.reload
      expect(invoice.aasm_state).to eq('published')
      expect(invoice.published_url).to eq('http://example.com')
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested invoice' do
      invoice = create(:invoice, user:)
      expect do
        delete :destroy, params: { id: invoice.to_param }
      end.to change(Invoice, :count).by(-1)
    end

    it 'renders a JSON response with a success message' do
      delete :destroy, params: { id: invoice.to_param }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['message']).to eq('successfully delete invoice!')
    end
  end
end
