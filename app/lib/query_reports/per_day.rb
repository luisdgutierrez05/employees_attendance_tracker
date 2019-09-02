# frozen_string_literal: true

module QueryReports
  # Generates query information to get entries
  #   per specific date, current day or past day.
  class PerDay < Base
    class << self
      # Generates an entry report by specific date, current day and past day.
      # @params date [String] date.
      # @params period_name [String] period name.
      # @params _period_type [String] period type.
      # @returns [Array] with where_clause and day value.
      def perform(date, period_name, _period_type)
        day = date || day_period(period_name)
        [where_clause, { day: day }]
      end

      private

      # Where conditions to find entries per day.
      # @returns [String] query conditions.
      def where_clause
        'DATE(checkin_at) = :day AND DATE(checkout_at) = :day'
      end

      # Gets day period attribute from url request.
      # @params period [String] period.
      # @returns [String] day period.
      # @notes returns nil if day period is invalid.
      def day_period(period)
        return nil if PERIODS[:day].exclude?(period)
        return Date.today.to_s if period == 'today'

        Date.today.prev_day.to_s if period == 'yesterday'
      end
    end
  end
end
