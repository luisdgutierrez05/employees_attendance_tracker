# frozen_string_literal: true

# == Schema Information
#
# Table name: entries
#
#  id          :uuid             not null, primary key
#  checkin_at  :datetime
#  checkout_at :datetime
#  user_id     :uuid
#  observation :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Entry < ApplicationRecord # :nodoc:
  # Set default per page value.
  self.per_page = 10

  # Constant
  REST_HOURS = 1

  # Associations
  belongs_to :user

  # Validations
  validates :checkin_at, :user_id, presence: true

  # Custom Validations
  validates_with EntryValidator

  # Instance Methods

  # Calculates worked hours per day.
  # @returns [Float] worked hours.
  # @notes returns nil if checkin_at or checkout_at are nil.
  def worked_hours
    return nil if checkin_at.nil? || checkout_at.nil?

    diff_time = checkout_at - checkin_at
    ((diff_time / 3600) - REST_HOURS).round(3)
  end
end
