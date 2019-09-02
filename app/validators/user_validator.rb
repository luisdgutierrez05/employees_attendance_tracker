# frozen_string_literal: true

# Class to validate information from a User instance.
class UserValidator < ActiveModel::Validator
  # Validates start_date attribute from User instance.
  # @params record [ActiveRecord Instance] user instance.
  def validate(record)
    @record = record

    valid_start_date?
  end

  private

  # Validates if start_date is a valid date.
  # @returns [Boolean] true/false
  def valid_start_date?
    return true if date_parsed?(@record.start_date.to_s)

    error_message = I18n.t('models.user.errors.invalid_date')
    add_error_record(:start_date, error_message)
  end

  # Adds error to record instance.
  # @params attribute [Symbol] attribute name.
  # @params error_message [String] Error message.
  # @returns [Boolean] true/false
  def add_error_record(attribute, error_message)
    return if error_message.nil?

    @record.errors[attribute] << error_message
  end

  # Parses value as Date.
  # @params value [String] date to be parsed.
  # @returns [Boolean] true/false
  def date_parsed?(value)
    true if Date.parse(value)
  rescue ArgumentError
    false
  end
end
