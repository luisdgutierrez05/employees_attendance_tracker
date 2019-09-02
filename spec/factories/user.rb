# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: User do
    sequence(:first_name) { |n| "Employee #{n}" }
    last_name { 'RunaHR' }
    sequence(:email) { |n| "employee#{n}@test.com" }
    date_of_birth { 32.years.ago }
    position { User::POSITIONS.sample }
    phone_number { '3002004000' }
    sequence(:address) { |n| "Street #{n}" }
    start_date { '01-02-2017' }
    dni { '8765432901' }
    password { 'Password123!' }
    password_confirmation { 'Password123!' }

    trait :admin do
      first_name { 'Admin' }
      email { 'admin@runahr.com' }
      admin { true }
      position { 'manager' }
    end
  end
end
