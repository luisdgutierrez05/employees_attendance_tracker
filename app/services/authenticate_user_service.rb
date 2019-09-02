# frozen_string_literal: true

# Handles authentication of users.
class AuthenticateUserService
  # initializes email and password attributes.
  # @params email [String] User email.
  # @params password [String] User password.
  # @returns a new instance [AuthenticateUserService]
  def initialize(email, password)
    @email = email
    @password = password
  end

  # Encodes JWT token base on User Id.
  # @returns [Hash] authentication token.
  def call
    return success_response if valid_auth_token?

    raise_invalid_credentials_exception unless authenticated?

    new_token = JsonWebToken.encode(user_id: current_user&.id)
    update_user_token(new_token)
    success_response(new_token)
  end

  private

  attr_reader :email, :password

  # Finds user by email.
  # @returns current_user [ActiveRecord Object] User object.
  def current_user
    @current_user ||= User.find_by(email: email)
  end

  # Checks if current user is authenticated.
  # @returns [Boolean] true/false
  def authenticated?
    current_user&.authenticate(password)
  end

  # Checks if token is valid
  # @returns [Boolean] true/false
  def valid_auth_token?
    return false if current_user&.auth_token.nil?

    payload = JsonWebToken.decode(current_user.auth_token)
    JsonWebToken.valid_payload?(payload)
  end

  # Updates user authentication token.
  # @params token [String] authentication token encoded.
  def update_user_token(token)
    current_user.update_attributes(auth_token: token)
  end

  # Builds response of success authentication.
  # @params new_token [String] new token. By default is nil.
  # @returns [Hash] login succesfull information.
  def success_response(new_token = nil)
    token = new_token.nil? ? current_user.auth_token : new_token
    { token: token, message: 'Login Successfull' }
  end

  # Raises an invalid credentials exception
  # @returns [CustomExceptions::AuthenticationError] invalid credentials
  def raise_invalid_credentials_exception
    error_message = I18n.t('exceptions.invalid_credentials')
    raise CustomExceptions::AuthenticationError, error_message
  end
end
