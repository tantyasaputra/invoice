module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from HandledError::AuthenticationError do |e|
      render json: { error: e.message }, status: 401
    end
  end
end
