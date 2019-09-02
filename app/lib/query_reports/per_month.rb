# frozen_string_literal: true

module QueryReports
  # Generates query information to get entries
  #   per current or last month.
  class PerMonth < Base
    class << self
      private

      # Where conditions to find entries per month.
      # @returns [String] query conditions.
      def where_clause
        '(DATE(checkin_at) >= :init_date AND DATE(checkout_at) >= :init_date)
         AND (DATE(checkin_at) <= :end_date AND DATE(checkout_at) <= :end_date)'
      end

      # Builds this month date ranges.
      # @returns [Hash] initial and end date of current month.
      def this_month_dates
        {
          init_date: Date.today.beginning_of_month.to_s,
          end_date: Date.today.end_of_month.to_s
        }
      end

      # Builds last month date ranges.
      # @returns [Hash] initial and end date of last month.
      def last_month_dates
        {
          init_date: Date.today.ago(1.month).beginning_of_month&.to_s,
          end_date: Date.today.ago(1.month).end_of_month&.to_s
        }
      end
    end
  end
end
