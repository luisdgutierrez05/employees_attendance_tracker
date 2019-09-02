# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  describe 'POST /api/v1/auth/login' do
    let(:base_path) { '/api/v1/auth/login' }
    let!(:user) { create(:user, :admin) }
    let(:headers) { { 'Content-Type': 'application/vnd.api+json' } }

    let(:valid_credentials) do
      {
        email: user.email,
        password: user.password
      }.to_json
    end

    let(:invalid_credentials) do
      {
        email: 'employee1@test.com',
        password: 'Password123ABC!'
      }.to_json
    end

    context 'when request is valid' do
      it 'returns an authentication token' do
        post base_path, params: valid_credentials, headers: headers

        expect(json.dig('token')).not_to be_nil
      end
    end

    context 'when request is invalid' do
      it 'returns a failure message' do
        post base_path, params: invalid_credentials, headers: headers
        error_message = I18n.t('exceptions.invalid_credentials')

        expect(json.dig('message')).to eq(error_message)
      end
    end
  end
end
