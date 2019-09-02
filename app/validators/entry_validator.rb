# frozen_string_literal: true

# Class to validate information from a Entry instance.
class EntryValidator < ActiveModel::Validator
  # Validates checkin_at attribute from Entry instance.
  # @params record [ActiveRecord Instance] entry instance.
  def validate(record)
    @record = record

    valid_checkin_at?
  end

  private

  # Validates if checkin_at is a valid date time.
  # @returns [Boolean] true/false
  def valid_checkin_at?
    return true if datetime_parsed?(@record.checkin_at.to_s)

    error_message = I18n.t('models.entry.errors.invalid_datetime')
    add_error_record(:checkin_at, error_message)
  end

  # Validates if checkout_at is a valid date time.
  # @returns [Boolean] true/false
  def valid_checkout_at?
    return if @record&.checkout_at.nil?
    return true if datetime_parsed?(@record.checkout_at.to_s)

    error_message = I18n.t('models.entry.errors.invalid_datetime')
    add_error_record(:checkout_at, error_message)
  end

  # Adds error to record instance.
  # @params attribute [Symbol] attribute name.
  # @params error_message [String] Error message.
  # @returns [Boolean] true/false
  def add_error_record(attribute, error_message)
    return if error_message.nil?

    @record.errors[attribute] << error_message
  end

  # Parses value as DateTime.
  # @params value [String] date time to be parsed.
  # @returns [Boolean] true/false
  def datetime_parsed?(value)
    true if DateTime.parse(value)
  rescue ArgumentError
    false
  end
end
