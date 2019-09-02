# frozen_string_literal: true

module QueryReports
  # Generates query information to get entries
  #   per current or last period.
  class Base
    class << self
      # Constants
      PERIODS = {
        day: %w[today yesterday],
        week: %w[thisweek lastweek],
        month: %w[thismonth lastmonth],
        year: %w[thisyear lastyear]
      }.freeze

      # Generates an entry report by specific current or last period type.
      # @params period [String] period name.
      # @params period_type [String] period type.
      # @returns [ActiveRecord::AssociationRelation] entries per period type.
      def perform(period_name, period_type)
        [where_clause, period_details(period_name, period_type)]
      end

      private

      # Gets period type details.
      # @params period [String] period name.
      # @params period_type [String] period type.
      # @returns [String] period.
      # @notes returns nil if period is invalid.
      def period_details(period, period_type)
        return nil if PERIODS[period_type.to_sym].exclude?(period)

        return this_period_dates(period_type) if period == "this#{period_type}"

        last_period_dates(period_type) if period == "last#{period_type}"
      end

      # Calls this period dates method base on period type.
      # @params period [String] period type.
      def this_period_dates(period_type)
        send("this_#{period_type}_dates")
      end

      # Calls last period dates method base on period type.
      # @params period [String] period type.
      def last_period_dates(period_type)
        send("last_#{period_type}_dates")
      end
    end
  end
end
