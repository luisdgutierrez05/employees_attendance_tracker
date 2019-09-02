# frozen_string_literal: true

# Handles general and custom exceptions.
module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity_request
    rescue_from ActiveRecord::RecordNotFound, with: :not_found_request
    rescue_from ActionController::RoutingError, with: :not_found_request
    rescue_from ActionController::UnknownFormat, with: :not_found_request
    rescue_from ActionController::ParameterMissing, with: :bad_request

    rescue_from CustomExceptions::InvalidRequestError, with: :bad_request
    rescue_from CustomExceptions::DecodeError, with: :invalid_auth_token

    rescue_from CustomExceptions::AuthenticationError,
                with: :unauthorized_request
    rescue_from CustomExceptions::MissingToken,
                with: :unprocessable_entity_request
    rescue_from CustomExceptions::InvalidToken,
                with: :unprocessable_entity_request
    rescue_from CustomExceptions::ExpiredSignature,
                with: :expired_signature_token
    rescue_from CustomExceptions::VerificationError,
                with: :verification_error_token
    rescue_from CustomExceptions::NotPermittedException,
                with: :forbidden_request

    private

    # JSON response with message; Status code 400 - Bad request
    def bad_request(error)
      details = { status: 400, error: 'Bad request', message: error.message }
      json_response(details, :invalid_request)
    end

    # JSON response with message; Status code 401 - Unauthorized
    def unauthorized_request(error)
      details = { status: 401, error: 'Unauthorized', message: error.message }
      json_response(details, :unauthorized)
    end

    # JSON response with message; Status code 404 - Not Found
    def not_found_request(error)
      details = { status: 404, error: 'Not found', message: error.message }
      json_response(details, :not_found)
    end

    # JSON response with message; Status code 422 - Unprocessable entity
    def unprocessable_entity_request(error)
      details = { status: 422, error: 'Unprocessable entity',
                  message: error.message }
      json_response(details, :unprocessable_entity)
    end

    # JSON response with message; Status code 401 - Invalid token
    def invalid_auth_token(error)
      details = { status: 401, error: 'Access denied!. Invalid token supplied.',
                  message: error.message }
      json_response(details, :unauthorized)
    end

    # JSON response with message; Status code 401 - Expired token
    def expired_signature_token(error)
      details = { status: 401, error: 'Access denied!. Token has expired.',
                  message: error.message }
      json_response(details, :unauthorized)
    end

    # JSON response with message; Status code 401 - Unverified token
    def verification_error_token(error)
      details = { status: 401, error: 'Access denied!. Token not verified.',
                  message: error.message }
      json_response(details, :unauthorized)
    end

    # JSON response with message; Status code 402 - Not Permitted
    def forbidden_request(error)
      details = { status: 403, error: 'Not Permitted', message: error.message }
      json_response(details, :forbidden)
    end
  end
end
