# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SwaggersController, type: :controller do
  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it 'returns the Swagger JSON documentation' do
      get :index
      json_response = JSON.parse(response.body)

      # Basic checks for the presence of keys in the Swagger documentation
      expect(json_response).to have_key('swagger')
      expect(json_response['swagger']).to eq('2.0')
      expect(json_response).to have_key('info')
      expect(json_response['info']).to include(
        'version' => '1.0.0',
        'title' => 'Invoice API Documentation',
        'description' => 'API Documentation for Invoice APPs'
      )
      expect(json_response['info']['contact']).to include(
        'name' => 'Invoice API Team'
      )
      expect(json_response['info']['license']).to include(
        'name' => 'MIT'
      )
    end
  end
end
