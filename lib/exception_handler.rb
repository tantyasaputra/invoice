# frozen_string_literal: true

module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from HandledError::AuthenticationError do |e|
      render json: { error: e.message }, status: 401
    end

    rescue_from HandledError::InvalidParamsError do |e|
      render json: { error: e.message }, status: 400
    end

    rescue_from JWT::DecodeError do |e|
      render json: { error: 'invalid token!' }, status: 401
    end
  end
end
