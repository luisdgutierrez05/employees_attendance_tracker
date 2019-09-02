# frozen_string_literal: true

# Report custom exceptions.
module CustomReportExceptions
  # Raises an exception if page number is invalid.
  # @return [CustomExceptions::InvalidRequestError] invalid request error.
  def raise_invalid_page_number_error
    message = I18n.t('exceptions.invalid_page_number')
    raise ::CustomExceptions::InvalidRequestError, message
  end

  # Raises an exception if user id is invalid.
  # @return [CustomExceptions::InvalidRequestError] invalid request error.
  def raise_invalid_user_id_error
    message = I18n.t('exceptions.invalid_user_id')
    raise ::CustomExceptions::InvalidRequestError, message
  end

  # Raises an exception if period name is invalid.
  # @return [CustomExceptions::InvalidRequestError] invalid request error.
  def raise_invalid_period_name_error
    message = I18n.t('exceptions.invalid_period_name')
    raise ::CustomExceptions::InvalidRequestError, message
  end

  # Raises an exception if date is invalid.
  # @return [CustomExceptions::InvalidRequestError] invalid request error.
  def raise_invalid_date_error
    message = I18n.t('exceptions.invalid_date')
    raise ::CustomExceptions::InvalidRequestError, message
  end
end
