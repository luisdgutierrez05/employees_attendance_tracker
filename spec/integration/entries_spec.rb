# frozen_string_literal: true

require 'swagger_helper'

describe 'Entries API' do
  # GET #index - no filters
  path '/entries' do
    get 'Retrieves all entries' do
      tags 'Entries'
      produces 'application/json', 'application/vnd.api+json'
      security [ Bearer: {} ]

      response '200', 'list of entries' do
        schema type: :object,
          properties: {
            id: { type: :string },
            checkin_at: { type: :string },
            checkout_at: { type: :string },
            observation: { type: :string },
            user_id: { type: :string }
          },
          required: %i[checkin_at user_id]

        run_test!
      end
    end
  end

  # GET #index - filter by user_id
  path '/entries?user_id={user_id}' do
    get 'Retrieves entries of user' do
      tags 'Entries'
      produces 'application/json', 'application/vnd.api+json'
      security [ Bearer: {} ]
      parameter name: :user_id, in: :path, type: :string, required: true, description: 'User ID'

      response '200', 'list of entries' do
        schema type: :object,
          properties: {
            id: { type: :string },
            checkin_at: { type: :string },
            checkout_at: { type: :string },
            observation: { type: :string },
            user_id: { type: :string }
          },
          required: %i[checkin_at user_id]

        run_test!
      end
    end
  end

  # GET #index - filter by email
  path '/entries?email={email}' do
    get 'Retrieves entries of user' do
      tags 'Entries'
      produces 'application/json', 'application/vnd.api+json'
      security [ Bearer: {} ]
      parameter name: :email, in: :path, type: :string, required: true, description: 'Email'

      response '200', 'list of entries' do
        schema type: :object,
          properties: {
            id: { type: :string },
            checkin_at: { type: :string },
            checkout_at: { type: :string },
            observation: { type: :string },
            user_id: { type: :string }
          },
          required: %i[checkin_at user_id]

        run_test!
      end
    end
  end

  # POST #create
  path '/entries' do
    post 'Creates an entry' do
      tags 'Entries'
      consumes 'application/json', 'application/vnd.api+json'
      security [ Bearer: {} ]
      parameter name: :entry, in: :body, schema: {
        type: :object,
        properties: {
          data: {
            type: :object,
            properties: {
              type: 'entries',
              attributes: {
                type: :object,
                required: %i[checkin_at user_id],
                properties: {
                  checkin_at: { type: :string, example: Time.now },
                  observation: { type: :string, example: 'observation sample' },
                  user_id: { type: :string, example: 'a7f47d94-6601-4658-b35e-f28b6da248a0' }
                }
              }
            }
          }
        }
      }

      response '201', 'entry created' do
        run_test!
      end

      response '422', 'invalid request' do
        let(:user) { { observation: 'foo' } }
        run_test!
      end
    end
  end

  # PUT #update
  path '/entries/{id}' do
    put 'Update Entry' do
      tags 'Entries'
      produces 'application/json', 'application/vnd.api+json'
      security [ Bearer: {} ]
      parameter name: :id, in: :path, type: :string, required: true, description: 'Entry ID'

      response '200', 'Entry updated' do
        parameter name: :entry, in: :body, schema: {
          type: :object,
          properties: {
            data: {
              type: :object,
              properties: {
                type: 'entries',
                attributes: {
                  type: :object,
                  properties: {
                    checkout_at: { type: :string, example: Time.now + 9.hours },
                  }
                }
              }
            }
          }
        }

        run_test!
      end

      response '404', 'entry not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end

  # GET #show
  path '/entries/{id}' do
    get 'Retrieves a entry' do
      tags 'Entries'
      produces 'application/json', 'application/vnd.api+json'
      security [ Bearer: {} ]
      parameter name: :id, in: :path, type: :string, required: true, description: 'Entry ID'

      response '200', 'Entry found' do
        schema type: :object,
          properties: {
            id: { type: :string },
            checkin_at: { type: :string },
            checkout_at: { type: :string },
            observation: { type: :string },
            user_id: { type: :string }
          },
          required: %i[checkin_at user_id]

        run_test!
      end

      response '404', 'entry not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end

  # DELETE #destroy
  path '/entries/{id}' do
    delete 'Destroy Entry' do
      tags 'Entries'
      produces 'application/json', 'application/vnd.api+json'
      security [ Bearer: {} ]
      parameter name: :id, in: :path, type: :string, required: true, description: 'Entry ID'

      response '200', 'Entry deleted' do
        run_test!
      end

      response '404', 'Entry not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
