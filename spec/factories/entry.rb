# frozen_string_literal: true

FactoryBot.define do
  factory :entry, class: Entry do
    checkin_at { Time.now }
    checkout_at { Time.now + 9.hours }
    observation { 'observation' }
    user { create(:user) }
  end
end
