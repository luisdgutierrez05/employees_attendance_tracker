# frozen_string_literal: true

require 'swagger_helper'

describe 'Authentication API' do
  path '/auth/login' do
    post 'Creates authentication' do
      tags 'Login'
      consumes 'application/json', 'application/vnd.api+json'
      security [ Bearer: {} ]
      parameter name: :auth, in: :body, schema: {
        type: :object,
        properties: {
          email: {
            type: :string,
            example:'admin@runahr.com'
          },
          password: {
            type: :string,
            example: 'Password123!'
          }
        },
        required: ['email', 'password']
      }

      response '201', 'user logged in' do
        run_test!
      end

      response '422', 'invalid request' do
        let(:Authorization) { { 'Authorization' => 'Bearer invalid' } }
        run_test!
      end
    end
  end
end
