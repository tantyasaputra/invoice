# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuthenticationsController, type: :controller do
  describe 'POST #login' do
    let(:user) do
      create(:user, email: 'user@example.com', password: 'correct_password', password_confirmation: 'correct_password')
    end

    context 'with valid credentials' do
      it 'returns a JWT token' do
        post :login, params: { authentication: { email: user.email, password: 'correct_password' } }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['token']).to be_present
        expect(json_response['user']['email']).to eq(user.email)
      end
    end

    context 'with invalid credentials' do
      it 'returns an error message' do
        post :login, params: { authentication: { email: user.email, password: 'wrong_password' } }

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to eq('invalid credentials!')
      end
    end

    context 'with non-existent user' do
      it 'returns an error message' do
        post :login, params: { authentication: { email: 'nonexistent@example.com', password: 'password123' } }

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to eq('invalid credentials!')
      end
    end
  end
end
