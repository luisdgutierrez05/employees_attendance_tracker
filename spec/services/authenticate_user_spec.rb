# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuthenticateUserService do
  let(:user) { create(:user) }

  subject(:valid_auth_obj) { described_class.new(user.email, user.password) }
  subject(:invalid_auth_obj) { described_class.new('jhon@test.com', 'Pass1A!') }

  describe '#call' do
    context 'when valid credentials' do
      it 'returns a new authentication token' do
        token = valid_auth_obj.call

        expect(token).not_to be_nil
      end
    end

    context 'when invalid credentials' do
      it 'raises an authentication error' do
        error_message = 'Invalid credentials'
        expect do
          invalid_auth_obj.call
        end.to raise_error CustomExceptions::AuthenticationError, error_message
      end
    end

    context 'when token already exist' do
      let(:current_token) { valid_auth_obj.call }

      before do
        current_token
      end

      it 'returns current authentication token' do
        token = valid_auth_obj.call

        expect(token).to eq(current_token)
      end
    end
  end
end
