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

require 'rails_helper'

RSpec.describe Entry, type: :model do
  describe 'Associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:checkin_at) }
    it { is_expected.to validate_presence_of(:user_id) }
  end

  describe 'Custom validations' do
    context 'validate checkin_at' do
      context 'when checkin_at is valid' do
        it 'returns no errors' do
          entry = build(:entry)

          validation_result = entry.valid?
          entry_error = entry.errors.full_messages

          expect(validation_result).to be_truthy
          expect(entry_error).to be_empty
        end
      end

      context 'when checkin_at is invalid' do
        it 'returns an invalid record message' do
          entry = build(:entry, checkin_at: 'invalid')

          validation_result = entry.valid?
          entry_error = entry.errors.full_messages.join(', ')
          error_message = "Checkin at can't be blank, Checkin at must be a valid Date Time with format yyyy-mm-dd hh:mm:ss"

          expect(validation_result).to be_falsey
          expect(entry_error).to eq(error_message)
        end
      end
    end
  end

  describe 'Instance methods' do
    context '#worked_hours' do
      context 'when checkin_at and checkout_at are empty' do
        let(:entry) { create(:entry, checkout_at: nil) }

        it 'returns nil' do
          expect(entry.worked_hours).to be_nil
        end
      end

      context 'when checkin_at and checkout_at are present' do
        let(:entry) { create(:entry) }

        it 'returns the calculated worked hours' do
          expect(entry.worked_hours).to eq(8)
        end
      end
    end
  end
end
