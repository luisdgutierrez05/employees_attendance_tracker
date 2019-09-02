# frozen_string_literal: true

module QueryReports
  # Generates query information to get entries
  #   per current or last year.
  class PerYear < Base
    class << self
      private

      # Where conditions to find entries per year.
      # @returns [String] query conditions.
      def where_clause
        '(DATE(checkin_at) >= :init_date AND DATE(checkout_at) >= :init_date)
         AND (DATE(checkin_at) <= :end_date AND DATE(checkout_at) <= :end_date)'
      end

      # Builds this year date ranges.
      # @returns [Hash] initial and end date of current year.
      def this_year_dates
        {
          init_date: Date.today.beginning_of_year.to_s,
          end_date: Date.today.end_of_year.to_s
        }
      end

      # Builds last year date ranges.
      # @returns [Hash] initial and end date of last year.
      def last_year_dates
        {
          init_date: Date.today.ago(1.year).beginning_of_year&.to_s,
          end_date: Date.today.ago(1.year).end_of_year&.to_s
        }
      end
    end
  end
end
