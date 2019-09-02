# frozen_string_literal: true

require 'swagger_helper'

describe 'Reports API' do
  # GET #index - all entries by user_id
  path '/reports?user_id={user_id}' do
    get 'Retrieves all entries' do
      tags 'Reports'
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

  # GET #index - Per day - specific date
  path '/reports?user_id={user_id}&date={date}' do
    get 'Retrieves entries by specific date' do
      tags 'Reports'
      produces 'application/json', 'application/vnd.api+json'
      security [ Bearer: {} ]
      parameter name: :user_id, in: :path, type: :string, required: true, description: 'User ID'
      parameter name: :date, in: :path, type: :string, required: true, description: 'Date'

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

  # GET #index - Per day - period today
  path '/reports?user_id={user_id}&period=today' do
    get 'Retrieves entries from today' do
      tags 'Reports'
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

  # GET #index - Per day - period yesterday
  path '/reports?user_id={user_id}&period=yesterday' do
    get 'Retrieves entries from yesterday' do
      tags 'Reports'
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

  # GET #index - Per week - period this week
  path '/reports?user_id={user_id}&period=thisweek' do
    get 'Retrieves entries from this week' do
      tags 'Reports'
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

  # GET #index - Per week - period last week
  path '/reports?user_id={user_id}&period=lastweek' do
    get 'Retrieves entries from last week' do
      tags 'Reports'
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

  # GET #index - Per month - period this month
  path '/reports?user_id={user_id}&period=thismonth' do
    get 'Retrieves entries from this month' do
      tags 'Reports'
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

  # GET #index - Per month - period last month
  path '/reports?user_id={user_id}&period=lastmonth' do
    get 'Retrieves entries from last month' do
      tags 'Reports'
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

  # GET #index - Per year - period this year
  path '/reports?user_id={user_id}&period=thisyear' do
    get 'Retrieves entries from this year' do
      tags 'Reports'
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

  # GET #index - Per year - period last year
  path '/reports?user_id={user_id}&period=lastyear' do
    get 'Retrieves entries from last year' do
      tags 'Reports'
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
end
