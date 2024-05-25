# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    before_action :authenticate_request!

    def index
      render json: { message: 'Success' }
    end
  end

  let(:user) { create(:user) }
  let(:headers) { { 'Authorization' => "#{token}" } }
  let(:token) { JWT.encode({ user_id: user.id }, ENV.fetch('SECRET_KEY'), 'HS256') }

  describe '#authenticate_request!' do
    context 'when the authorization header is missing' do
      before do
        request.headers.merge!({})
        get :index
      end

      it 'raises an authentication error' do
        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('missing authorization header')
      end
    end

    context 'when the token is invalid' do
      let(:invalid_token) { 'invalid.token.here' }
      before do
        request.headers.merge!({ 'Authorization' => "#{invalid_token}" })
        get :index
      end

      it 'raises an authentication error' do
        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('invalid token!')
      end
    end

    context 'when the token is valid' do
      before do
        request.headers.merge!(headers)
        get :index
      end

      it 'authenticates the user' do
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('Success')
      end
    end
  end

  describe '#authorization_header' do
    context 'when the authorization header is present' do
      before do
        request.headers.merge!(headers)
      end

      it 'returns the authorization header' do
        expect(controller.send(:authorization_header)).to eq(headers['Authorization'])
      end
    end

    context 'when the authorization header is missing' do
      before do
        request.headers.merge!({})
      end

      it 'raises an authentication error' do
        expect { controller.send(:authorization_header) }.to raise_error(HandledError::AuthenticationError, 'missing authorization header')
      end
    end
  end
end
