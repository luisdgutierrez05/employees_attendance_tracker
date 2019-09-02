# frozen_string_literal: true

# Authorizes API request base on User and JWT token.
class AuthorizeApiRequestService
  # initializes headers attribute.
  # @params headers [Hash] headers. By default is {}.
  # @returns a new instance [AuthorizeApiRequestService]
  def initialize(headers = {})
    @headers = headers
  end

  # Calls user method to verify user information with JWT token authorization.
  # @returns [ActiveRecord Object] User object.
  def call
    { user: user }
  end

  private

  attr_reader :headers

  # Gets JWT token encoded from authorization header.
  # @returns JWT token encoded.
  # @raises missing token exception is token is missing.
  def http_authentication_header
    authorization_header = headers['Authorization']
    return authorization_header.split(' ').last if authorization_header.present?

    raise_missing_token_exception
  end

  # Decodes authentication token
  # @returns [String] JWT token decoded
  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(http_authentication_header)
  end

  # Finds User base on user_id attr from decoded authentication token.
  # @returns @user [ActiveRecord Object] User object.
  # @raises an invalid token exception when token is invalid.
  def user
    @user ||= User.find(decoded_auth_token.dig(:user_id)) if decoded_auth_token
  rescue ActiveRecord::RecordNotFound
    raise_invalid_token_exception
  end

  # Raises an invalid token exception
  # @params exception [Exception] exception object
  # @returns [CustomExceptions::InvalidToken] invalid token exception
  def raise_invalid_token_exception
    message = I18n.t('exceptions.invalid_token')
    raise CustomExceptions::InvalidToken, message
  end

  # Raises missing token exception
  # @returns [CustomExceptions::MissingToken] missing token exception
  def raise_missing_token_exception
    message = I18n.t('exceptions.missing_token')
    raise CustomExceptions::MissingToken, message
  end
end
