# frozen_string_literal: true

module Api
  module V1
    class ApiController < ActionController::API # :nodoc:
      include Response
      include ExceptionHandler

      attr_reader :current_user
      before_action :authorize_request!, except: [:routing_error]
      before_action :admin_authorize!, except: [:routing_error]

      # Raises an exception when route is invalid.
      # @returns [ActionController::RoutingError] invalid route exception.
      def routing_error
        error_message = I18n.t('exceptions.invalid_route')
        raise ActionController::RoutingError, error_message
      end

      private

      # Authorize Api request base on User information.
      # @returns current_user [ActiveRecord Object] user instance.
      def authorize_request!
        auth = AuthorizeApiRequestService.new(request.headers)
        @current_user = auth.call[:user]
      end

      # Checks if current user is admin.
      # @returns true if current is admin.
      # @raises [CustomExceptions::NotPermittedException] permission denied.
      def admin_authorize!
        exception = CustomExceptions::NotPermittedException
        error_message = I18n.t('exceptions.permission_denied')
        raise exception, error_message unless current_user.admin?

        true
      end

      # Generates pagination details.
      # @returns [Hash] pagination details.
      def pagination_details(collection)
        {
          current_page: collection.current_page,
          next_page: collection.next_page,
          previous_page: collection.previous_page,
          first_page: collection.current_page == 1,
          last_page: collection.next_page.blank?,
          total_pages: collection.total_pages,
          total_count: collection.total_entries
        }
      end
    end
  end
end
