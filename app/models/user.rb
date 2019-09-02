# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :uuid             not null, primary key
#  first_name      :string
#  last_name       :string
#  email           :string           not null
#  password_digest :string           not null
#  date_of_birth   :date
#  admin           :boolean          default(FALSE)
#  phone_number    :string
#  start_date      :date
#  end_date        :date
#  dni             :string
#  address         :string
#  position        :string
#  auth_token      :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord # :nodoc:
  # Constants
  POSITIONS = %w[backend frontend devops designer marketing sales
                 onboarding manager].freeze

  # Associations
  has_many :entries

  # Validations
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, :last_name, :date_of_birth, :dni, :position,
            :start_date, :phone_number, :address, presence: true
  validates :password, presence: true, length: { minimum: 8 },
                       allow_nil: true, on: :create
  validates_inclusion_of :position, in: POSITIONS

  # Custom Validations
  validates_with UserValidator

  # Scopes
  scope :employees, -> { where(admin: false) }
end
