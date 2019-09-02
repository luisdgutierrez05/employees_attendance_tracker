# frozen_string_literal: true

# Encodes and decodes JWT tokens.
module JsonWebToken
  class << self
    # Constant
    SECRET_KEY = Rails.application.secrets.secret_key_base.to_s

    # Encodes payload data
    # @params payload [Hash] data to be encode.
    # @params exp [String] expiration time.
    # @returns [String] JWT token encoded
    def encode(payload, exp = 24.hours.from_now.to_i)
      return nil if payload.empty?

      payload.merge!(meta, exp: exp)
      JWT.encode(payload, SECRET_KEY)
    end

    # Decodes token given by user
    # @params token [String] JWT token
    # @returns [Hash] JWT token decoded
    def decode(token)
      return nil if token.nil?

      decoded = JWT.decode(token, SECRET_KEY)[0]
      HashWithIndifferentAccess.new(decoded)
    rescue JWT::ExpiredSignature => e
      reset_auth_token(token)
      raise_expired_signature_exception(e)
    rescue JWT::DecodeError => e
      raise_decode_error_exception(e)
    rescue JWT::VerificationError => e
      raise_verification_error_exception(e)
    end

    # Checks if payload is valid.
    # @params payload [Hash] payload information.
    # @returns [Boolean] true/false
    def valid_payload?(payload)
      return false if expired?(payload) || meta_valid?(payload)

      true
    end

    private

    def reset_auth_token(token)
      user = User.find_by(auth_token: token)
      user&.update_attributes(auth_token: nil)
    end

    # Generates a payload meta information.
    #   expiration time token by default is 24 hour.
    # @returns [Hash] payload meta information.
    def meta
      { iss: 'issuer_name', aud: 'user' }
    end

    # Checks if token has expired.
    # @params payload [Hash] payload information.
    # @returns [Boolean] true/false
    def expired?(payload)
      Time.at(payload['exp']) < Time.now
    end

    # Checks if payload meta info is valid.
    # @params payload [Hash] payload information.
    # @returns [Boolean] true/false
    def meta_valid?(payload)
      payload['iss'] != meta[:iss] || payload['aud'] != meta[:aud]
    end

    # Raises JWT decode error exception
    # @params exception [Error] exception object
    # @returns [CustomExceptions::DecodeError] decode error exception
    def raise_decode_error_exception(exception)
      raise CustomExceptions::DecodeError, exception.message
    end

    # Raises expired signature error exception
    # @params exception [Error] exception object
    # @returns [CustomExceptions::ExpiredSignature] expired signature exception
    def raise_expired_signature_exception(exception)
      raise CustomExceptions::ExpiredSignature, exception.message
    end

    # Raises verification error exception
    # @params exception [Error] exception object
    # @returns [CustomExceptions::VerificationError] verify error exception
    def raise_verification_error_exception(exception)
      raise CustomExceptions::VerificationError, exception.message
    end
  end
end
