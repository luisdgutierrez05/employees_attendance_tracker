# frozen_string_literal: true

module Api
  module V1
    # Handles Reports
    class ReportsController < ApiController
      skip_before_action :admin_authorize!, if: :employee_report?

      # GET /index
      # For employees:
      #   Displays all entries of current user.
      # For admin:
      #   Displays all entries base on query params and report type.
      # @returns [Hash] list of entries.
      def index
        result = ReportsService.new(@current_user, query_params).perform
        json_response(result, :ok, pagination_details(result))
      end

      private

      # Gets query parameters only.
      # @returns [Hash] query parameters.
      def query_params
        request.query_parameters
      end

      # Validates access only for per day reports when
      #   current user is an employee.
      # @returns [Boolean] true/false
      def employee_report?
        period = params&.dig(:period)&.downcase
        date = params&.dig(:date)
        return true if date || period && %w[today yesterday].include?(period)

        false
      end
    end
  end
end
