# frozen_string_literal: true

module Api
  module V1
    # Handles authentication process.
    class AuthenticationController < ApiController
      skip_before_action :authorize_request!, only: :create
      skip_before_action :admin_authorize!, only: :create

      # Authenticates current user.
      # @returns authentication_token [String] authentication token.
      def create
        token = AuthenticateUserService.new(email, password).call
        json_response(token)
      end

      private

      # Gets authentication attributes from request parameters.
      # @returns [Hash] the authentication parameters.
      def auth_params
        params.permit(:email, :password)
      end

      # Gets email parameter.
      # @returns [String] email value.
      def email
        auth_params&.dig(:email)
      end

      # Gets password parameter.
      # @returns [String] password value.
      def password
        auth_params&.dig(:password)
      end
    end
  end
end
