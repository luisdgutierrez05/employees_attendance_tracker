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

class EntrySerializer < ActiveModel::Serializer # :nodoc:
  type :entries

  attributes :id, :checkin_at, :checkout_at, :user_id, :worked_hours,
             :observation

  def checkin_at
    object.checkin_at&.strftime('%m-%d-%Y %H:%M:%S %p')
  end

  def checkout_at
    object.checkout_at&.strftime('%m-%d-%Y %H:%M:%S %p')
  end
end
