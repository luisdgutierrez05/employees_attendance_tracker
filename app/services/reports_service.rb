# frozen_string_literal: true

class ReportsService # :nodoc:
  include CustomReportExceptions

  # Attributes
  attr_reader :entries, :query_params

  # Constants
  PERIODS = {
    day: %w[today yesterday],
    week: %w[thisweek lastweek],
    month: %w[thismonth lastmonth],
    year: %w[thisyear lastyear]
  }.freeze

  # initializes entries and query_params attributes.
  # @params user [Object] User instance.
  # @params query_params [Hash] query parameters.
  # @returns a new instance [Reports::EmployeesService]
  def initialize(user, query_params)
    @query_params = query_params
    @entries = user_id_param ? user_entries : user.entries
  end

  def perform
    validations

    %i[week month year].each do |p|
      return send("report_per_#{p}") if PERIODS[p].include?(period_param)
    end

    return report_per_day if date_param || period_param

    default_query
  end

  private

  # Gets page attribute from url request.
  # @returns [String] page number.
  def page_number
    query_params&.dig(:page)
  end

  # Gets date attribute from url request.
  # @returns [String] day.
  def date_param
    query_params&.dig(:date)
  end

  # Gets period attribute from url request.
  # @returns [String] period.
  def period_param
    query_params&.dig(:period)&.downcase
  end

  # Gets User Id attribute from url request.
  # @returns [String] User Id.
  def user_id_param
    query_params&.dig(:user_id)
  end

  # Gets entries filtered by User Id parameter.
  # @returns [ActiveRecord::AssociationRelation] entries results.
  # @raises CustomExceptions::InvalidRequestError if user id is nil.
  def user_entries
    user = User.find_by(id: user_id_param)
    raise_invalid_user_id_error if user.nil?

    user&.entries
  end

  # Generates dinamic query condition base on where_sql and params attributes.
  #   paginated with page param from request. By default is nil.
  #   ordered by checkin_at descending.
  # @returns [ActiveRecord::AssociationRelation] entries results.
  def base_where_query(where_clause, params)
    entries.where(where_clause, params)
           .paginate(page: page_number)
           .order(checkin_at: :desc)
  end

  # Gets all entries of current user.
  # @returns [ActiveRecord::AssociationRelation] all entries.
  def default_query
    base_where_query(nil, nil)
  end

  # Builds dynamic methods per each period to get entries report.
  #
  # report_per_day:
  #   entries report by specific date, current or last day.
  #
  # report_per_week:
  #   entries report by current or last week.
  #
  # report_per_month:
  #   entries report by current or last month.
  #
  # report_per_year:
  #   entries report by current or last year.
  # @returns [ActiveRecord::AssociationRelation] entries results.
  %i[day week month year].each do |period_type|
    define_method "report_per_#{period_type}" do
      module_name = "QueryReports::Per#{period_type.to_s.titleize}".constantize
      params = period_type == :day ? [date_param, period_param] : period_param
      query_info = module_name.perform(*params, period_type)

      base_where_query(*query_info)
    end
  end

  # Checks if page param is an integer value.
  # @returns [Boolean] true/false
  # @raises CustomExceptions::InvalidRequestError if page number is invalid.
  def valid_page_number?
    page = page_number&.to_i
    raise_invalid_page_number_error if page <= 0
  end

  # Checks if period name param is valid.
  # @returns [Boolean] true/false
  # @raises CustomExceptions::InvalidRequestError if period name is invalid.
  def valid_period_name?
    period_list = PERIODS.values.flatten
    raise_invalid_period_name_error if period_list.exclude?(period_param)
  end

  # Checks if date param is valid.
  # @returns [Boolean] true/false
  # @raises CustomExceptions::InvalidRequestError if date cannot be parsed.
  def valid_date?
    true if Date.parse(date_param)
  rescue ArgumentError
    raise_invalid_date_error
  end

  # Validates page, period and date parameters.
  # @returns true if are valid.
  # @raises an exception if are invalid.
  def validations
    valid_page_number? if page_number
    valid_period_name? if period_param
    valid_date? if date_param
  end
end
