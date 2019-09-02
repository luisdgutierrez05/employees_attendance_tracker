# frozen_string_literal: true

module QueryReports
  # Generates query information to get entries
  #   per current or last week.
  class PerWeek < Base
    class << self
      private

      # Where conditions to find entries per week.
      # @returns [String] query conditions.
      def where_clause
        '(DATE(checkin_at) >= :init_date AND DATE(checkout_at) >= :init_date)
         AND (DATE(checkin_at) <= :end_date AND DATE(checkout_at) <= :end_date)'
      end

      # Builds this week date ranges.
      # @returns [Hash] initial and end date of current week.
      def this_week_dates
        {
          init_date: Date.today.beginning_of_week.to_s,
          end_date: Date.today.end_of_week.to_s
        }
      end

      # Builds last week date ranges.
      # @returns [Hash] initial and end date of last week.
      def last_week_dates
        {
          init_date: Date.today.ago(1.week).beginning_of_week&.to_s,
          end_date: Date.today.ago(1.week).end_of_week&.to_s
        }
      end
    end
  end
end
