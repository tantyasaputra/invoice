# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ItemsController, type: :controller do
  let(:user) { create(:user) }
  let(:headers) { { 'Authorization' => token.to_s } }
  let(:token) { JWT.encode({ user_id: user.id }, ENV.fetch('SECRET_KEY'), 'HS256') }
  let(:valid_attributes) do
    {
      name: 'Item 1',
      description: 'Item 1 Description',
      unit_price: 10.0
    }
  end

  let(:invalid_attributes) do
    {
      name: '',
      description: 'Item 1 Description',
      unit_price: 10.0
    }
  end

  before do
    request.headers.merge!(headers)
  end

  describe 'GET #index' do
    it 'returns a success response' do
      create(:item)
      get :index
      expect(response).to be_successful

      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq(1)
      expect(json_response.map { |item| item['name'] }).to contain_exactly(*Item.pluck(:name))
    end
  end

  describe 'GET #show' do
    context 'with valid id' do
      let(:item) { create(:item) }

      it 'returns a success response' do
        get :show, params: { id: item.to_param }
        expect(response).to be_successful
      end
    end

    context 'with invalid id' do
      it 'returns a not found response' do
        get :show, params: { id: 0 }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('item not found')
      end
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Item' do
        expect do
          post :create, params: { item: valid_attributes }
        end.to change(Item, :count).by(1)

        item = Item.last
        expect(item.name).to eq(valid_attributes[:name])
        expect(item.description).to eq(valid_attributes[:description])
        expect(item.unit_price).to eq(valid_attributes[:unit_price])
      end

      it 'renders a JSON response with the new item' do
        post :create, params: { item: valid_attributes }
        expect(response).to have_http_status(:created)

        json_response = JSON.parse(response.body).with_indifferent_access
        expect(json_response[:name]).to eq(valid_attributes[:name])
        expect(json_response[:description]).to eq(valid_attributes[:description])
        expect(json_response[:unit_price].to_f).to eq(valid_attributes[:unit_price])
      end
    end

    context 'with invalid params missing name' do
      it 'renders a JSON response with errors for the new item' do
        post :create, params: { item: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)

        json_response = JSON.parse(response.body).with_indifferent_access
        expect(json_response[:name]).to include("can't be blank")
      end
    end
  end

  describe 'PATCH/PUT #update' do
    let(:item) { create(:item) }

    context 'with valid params' do
      let(:new_attributes) do
        {
          name: 'Updated Item',
          description: 'Updated Description',
          unit_price: 20.0
        }
      end

      it 'updates the requested item' do
        put :update, params: { id: item.to_param, item: new_attributes }
        item.reload

        expect(item.name).to eq('Updated Item')
        expect(item.description).to eq('Updated Description')
        expect(item.unit_price).to eq(20.0)
      end

      it 'renders a JSON response with the item' do
        put :update, params: { id: item.to_param, item: new_attributes }
        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body).with_indifferent_access
        expect(json_response[:name]).to eq(new_attributes[:name])
        expect(json_response[:description]).to eq(new_attributes[:description])
        expect(json_response[:unit_price].to_f).to eq(new_attributes[:unit_price])
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the item' do
        put :update, params: { id: item.to_param, item: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:item) { create(:item) }

    it 'destroys the requested item' do
      expect do
        delete :destroy, params: { id: item.to_param }
      end.to change(Item, :count).by(-1)
    end

    it 'renders a no content response' do
      delete :destroy, params: { id: item.to_param }
      expect(response).to have_http_status(:no_content)
    end
  end
end
