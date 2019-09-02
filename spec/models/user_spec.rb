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

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Associations' do
    it { is_expected.to have_many(:entries) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:date_of_birth) }
    it { is_expected.to validate_presence_of(:position) }
    it { is_expected.to validate_presence_of(:dni) }
    it { is_expected.to validate_presence_of(:start_date) }
    it { is_expected.to validate_presence_of(:phone_number) }
    it { is_expected.to validate_presence_of(:address) }
    it { is_expected.to validate_presence_of(:password) }

    it { is_expected.to allow_value('email@test.com').for(:email) }
    it { is_expected.to_not allow_value('foo').for(:email) }

    it { is_expected.to validate_inclusion_of(:position).in_array(User::POSITIONS) }
    it { is_expected.to validate_length_of(:password).is_at_least(8) }

    it { create(:user); is_expected.to validate_uniqueness_of(:email) }
  end

  describe 'Custom validations' do
    context 'validate start_date' do
      context 'when start_date is valid' do
        it 'returns no errors' do
          user = build(:user)

          validation_result = user.valid?
          user_error = user.errors.full_messages

          expect(validation_result).to be_truthy
          expect(user_error).to be_empty
        end
      end

      context 'when start_date is invalid' do
        it 'returns an invalid record message' do
          user = build(:user, start_date: 'invalid')

          validation_result = user.valid?
          user_error = user.errors.full_messages.join(', ')
          error_message = "Start date can't be blank, Start date must be a valid date"

          expect(validation_result).to be_falsey
          expect(user_error).to eq(error_message)
        end
      end
    end
  end

  describe 'Scopes' do
    context '.employees' do
      context 'when there are employees' do
        before do
          create_list(:user, 3)
          create(:user, admin: true)
        end

        it 'returns only employees' do
          expect(User.employees).to_not be_empty
          expect(User.employees.size).to eq(3)
        end
      end

      context 'when there are no employees' do
        before do
          create(:user, admin: true)
        end

        it 'returns an empty array' do
          expect(User.employees).to be_empty
        end
      end
    end
  end
end
