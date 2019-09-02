# frozen_string_literal: true

class FilterEntriesService # :nodoc:
  # Attributes
  attr_reader :query_params

  def initialize(query_params)
    @query_params = query_params
  end

  def perform
    valid_page_number? if page_number
    return filter_by_user if user_id

    return filter_by_email if email

    default_query
  end

  private

  # Gets user Id from parameters.
  # @returns [string] User Id.
  def user_id
    query_params&.dig(:user_id)
  end

  # Gets user email from parameters.
  # @returns [string] User email.
  def email
    query_params&.dig(:email)
  end

  # Gets page attribute from url request.
  # @return [String] page number.
  def page_number
    query_params&.dig(:page)
  end

  # Generates dinamic query condition base on where_sql and params attributes.
  #   paginated with page param from request. By default is nil.
  #   ordered by checkin_at descending.
  # @returns [ActiveRecord::AssociationRelation] entries results.
  def base_where_query(where_clause, params)
    Entry.where(where_clause, params)
         .paginate(page: page_number)
         .order(checkin_at: :desc)
  end

  # Gets all entries.
  # @returns [ActiveRecord::AssociationRelation] all entries.
  def default_query
    base_where_query(nil, nil)
  end

  # Gets all entries filtered by user id.
  # @returns [ActiveRecord::AssociationRelation] entries by user id.
  def filter_by_user
    Entry.where(user_id: user_id)
         .paginate(page: page_number)
         .order(checkin_at: :desc)
  end

  # Gets all entries filtered by user email.
  # @returns [ActiveRecord::AssociationRelation] entries by email.
  def filter_by_email
    Entry.joins(:user)
         .where('users.email = :email', email: email)
         .paginate(page: page_number)
         .order(checkin_at: :desc)
  end

  # Checks if page param is an integer value.
  # @returns [Boolean] true/false
  def valid_page_number?
    page = page_number&.to_i
    raise_invalid_page_number_error if page <= 0
  end

  # Raises an exception if page number is invalid.
  # @return [CustomExceptions::InvalidRequestError] invalid request error.
  def raise_invalid_page_number_error
    message = I18n.t('exceptions.invalid_page_number')
    raise ::CustomExceptions::InvalidRequestError, message
  end
end
