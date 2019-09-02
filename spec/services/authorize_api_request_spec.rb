# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuthorizeApiRequestService do
  let!(:user) { create(:user) }
  let(:header) { { 'Authorization' => token_generator(user.id) } }

  subject(:invalid_request_obj) { described_class.new({}) }
  subject(:request_obj) { described_class.new(header) }

  describe '#call' do
    context 'when valid request' do
      it 'returns user object' do
        result = request_obj.call
        expect(result&.dig(:user)).to eq(user)
      end
    end

    context 'when invalid request' do
      context 'when missing token' do
        it 'raises a MissingToken error' do
          message = I18n.t('exceptions.missing_token')

          expect do
            invalid_request_obj.call
          end.to raise_error(CustomExceptions::MissingToken, message)
        end
      end

      context 'when invalid token' do
        subject(:invalid_request_obj) do
          user_id = SecureRandom.uuid
          described_class.new('Authorization' => token_generator(user_id))
        end

        it 'raises an InvalidToken error' do
          expect do
            invalid_request_obj.call
          end.to raise_error(CustomExceptions::InvalidToken, 'Invalid token')
        end
      end

      context 'when token is expired' do
        let(:header) { { 'Authorization' => expired_token_generator(user.id) } }
        subject(:request_obj) { described_class.new(header) }

        it 'raises CustomExceptions::ExpiredSignature error' do
          error_message = I18n.t('exceptions.expired_signature')
          expect do
            request_obj.call
          end.to raise_error CustomExceptions::ExpiredSignature, error_message
        end
      end

      context 'when fake token' do
        let(:header) { { 'Authorization' => 'faketoken' } }
        subject(:invalid_request_obj) { described_class.new(header) }

        it 'handles JWT::DecodeError' do
          error_message = I18n.t('exceptions.jwt_decode_error')
          expect do
            invalid_request_obj.call
          end.to raise_error(CustomExceptions::DecodeError, error_message)
        end
      end
    end
  end
end
