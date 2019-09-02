# frozen_string_literal: true

require 'swagger_helper'

describe 'Users API' do
  # GET #index
  path '/users' do
    get 'Retrieves all users' do
      tags 'Users'
      produces 'application/json', 'application/vnd.api+json'
      security [ Bearer: {} ]

      response '200', 'list of users' do
        schema type: :object,
          properties: {
            id: { type: :string },
            first_name: { type: :string },
            last_name: { type: :string },
            dni: { type: :string },
            email: { type: :string },
            phone_number: { type: :string },
            date_of_birth: { type: :string },
            position: { type: :string },
            start_date: { type: :string },
            address: { type: :string },
          },
          required: %i[first_name last_name dni email phone_number date_of_birth position start_date address password password_confirmation]

        run_test!
      end
    end
  end

  # POST #create
  path '/users' do
    post 'Creates a user' do
      tags 'Users'
      consumes 'application/json', 'application/vnd.api+json'
      security [ Bearer: {} ]
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          data: {
            type: :object,
            properties: {
              type: 'users',
              attributes: {
                type: :object,
                required: %i[first_name last_name dni email phone_number date_of_birth position start_date address password password_confirmation],
                properties: {
                  first_name: { type: :string, example: 'Employee' },
                  last_name: { type: :string, example: 'RunaHR' },
                  dni: { type: :string, example: '8765432901' },
                  email: { type: :string, example: 'employee@test.com' },
                  phone_number: { type: :string, example: '3002004000' },
                  date_of_birth: { type: :string, example: '1991-09-02' },
                  position: { type: :string, example: 'backend' },
                  start_date: { type: :string, example: '2017-09-02' },
                  address: { type: :string, example: 'Av. 100' },
                  password: { type: :string, example: 'Password123!' },
                  password_confirmation: { type: :string, example: 'Password123!' }
                }
              }
            }
          }
        }
      }

      response '201', 'user created' do
        let(:user) do
          {
            first_name: "Dev one",
            last_name: "Runa",
            dni: "32344654",
            email: "devone@runa.com",
            phone_number: "4002003023",
            date_of_birth: "09-02-1990",
            position: "backend",
            start_date: "01-01-2017",
            address: "Ave 80",
            password: "UOZ123456",
            password_confirmation: "UOZ123456"
          }
        end
        run_test!
      end

      response '422', 'invalid request' do
        let(:user) { { first_name: 'foo' } }
        run_test!
      end
    end
  end

  # PUT #update
  path '/users/{id}' do
    put 'Update User' do
      tags 'Users'
      produces 'application/json', 'application/vnd.api+json'
      security [ Bearer: {} ]
      parameter name: :id, in: :path, type: :string, required: true, description: 'User ID'

      response '200', 'User updated' do
        parameter name: :user, in: :body, schema: {
          type: :object,
          properties: {
            data: {
              type: :object,
              properties: {
                type: 'users',
                attributes: {
                  type: :object,
                  properties: {
                    phone_number: { type: :string, example: '3015006110' },
                    date_of_birth: { type: :string, example: '1985-10-10' },
                    position: { type: :string, example: 'frontend' },
                    start_date: { type: :string, example: '2016-05-05' }
                  }
                }
              }
            }
          }
        }

        let(:id) { create(:user).id }
        run_test!
      end

      response '404', 'user not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end

  # GET #show
  path '/users/{id}' do
    get 'Retrieves a user' do
      tags 'Users'
      produces 'application/json', 'application/vnd.api+json'
      security [ Bearer: {} ]
      parameter name: :id, in: :path, type: :string, required: true, description: 'User ID'

      response '200', 'User found' do
        schema type: :object,
          properties: {
            id: { type: :string },
            first_name: { type: :string },
            last_name: { type: :string },
            dni: { type: :string },
            email: { type: :string },
            phone_number: { type: :string },
            date_of_birth: { type: :string },
            position: { type: :string },
            start_date: { type: :string },
            address: { type: :string },
          },
          required: %i[first_name last_name dni email phone_number date_of_birth position start_date address password password_confirmation]

        let(:id) { create(:user).id }
        run_test!
      end

      response '404', 'user not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end

  # DELETE #destroy
  path '/users/{id}' do
    delete 'Destroy User' do
      tags 'Users'
      produces 'application/json', 'application/vnd.api+json'
      security [ Bearer: {} ]
      parameter name: :id, in: :path, type: :string, required: true, description: 'User ID'

      response '200', 'User deleted' do
        run_test!
      end

      response '404', 'User not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
