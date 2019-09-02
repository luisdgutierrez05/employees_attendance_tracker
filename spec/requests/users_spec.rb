# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let(:api_path) { '/api/v1/users' }
  let!(:admin_user) { create(:user, :admin) }
  let(:headers) { valid_headers(admin_user.id) }

  let(:valid_attributes) do
    {
      first_name: 'Employee 1',
      last_name: 'RunaHR',
      email: 'employee1@test.com',
      date_of_birth: 32.years.ago,
      position: User::POSITIONS.sample,
      phone_number: '3002004000',
      start_date: '04-09-2015',
      dni: '1765432901',
      address: 'Ave 50',
      password: 'Password123!',
      password_confirmation: 'Password123!'
    }
  end

  let(:invalid_attributes) do
    {
      first_name: nil,
      last_name: nil,
      email: nil,
      date_of_birth: nil,
      position: nil,
      address: nil,
      phone_number: nil,
      start_date: nil,
      dni: nil,
      password: nil,
      password_confirmation: nil
    }
  end

  let(:invalid_id) { '2a00e2eb-e16c-7d06-b822-10098000f000' }

  describe 'GET #index' do
    it 'returns a list of users' do
      create_list(:user, 3)
      get api_path, params: {}, headers: headers

      expect(response).to have_http_status(:success)
      expect(response).to be_successful
      expect(User.employees.size).to eq(3)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      let(:user_attributes) do
        {
          data: {
            attributes: valid_attributes
          }
        }.to_json
      end

      it 'creates a new User' do
        post api_path, params: user_attributes, headers: headers

        expect(response).to have_http_status(201)
        expect(response.content_type).to eq('application/vnd.api+json')
        expect(User.employees.size).to eq(1)
        expect(json.dig('data', 'attributes', 'first-name')).to eq('Employee 1')
      end
    end

    context 'with invalid params' do
      let(:user_attributes) do
        {
          data: {
            attributes: invalid_attributes
          }
        }.to_json
      end

      it 'renders a JSON response with errors for the new user' do
        post api_path, params: user_attributes, headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/vnd.api+json')
        expect(json.dig('error')).to eq('Unprocessable entity')

        error_sample = json.dig('message').split(',').first
        expect(error_sample).to eq("Validation failed: Password can't be blank")
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        {
          data: {
            type: 'users',
            attributes: {
              date_of_birth: '28-08-1994',
              start_date: '02-01-2018'
            }
          }
        }.to_json
      end

      it 'updates the requested user' do
        user = create(:user)
        put "#{api_path}/#{user.id}", params: new_attributes, headers: headers

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/vnd.api+json')
        expect(json.dig('data', 'attributes', 'date-of-birth')).to eq('1994-08-28')
        expect(json.dig('data', 'attributes', 'start-date')).to eq('2018-01-02')
      end
    end

    context 'with invalid params' do
      let(:invalid_attributes) do
        {
          data: {
            type: 'users',
            attributes: {
              date_of_birth: nil,
              start_date: ''
            }
          }
        }.to_json
      end

      it 'returns a JSON response with validation errors' do
        user = create(:user)
        put "#{api_path}/#{user.id}", params: invalid_attributes, headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/vnd.api+json')
        expect(json.dig('error')).to eq('Unprocessable entity')

        error_message = "Validation failed: Date of birth can't be blank, Start date can't be blank, Start date must be a valid date"
        expect(json['message']).to eq(error_message)
      end
    end

    context 'with invalid User Id' do
      it 'renders a JSON response with not found error' do
        put "#{api_path}/#{invalid_id}", params: {}, headers: headers

        expect(response).to have_http_status(:not_found)
        expect(response.content_type).to eq('application/vnd.api+json')
        expect(json.dig('error')).to eq('Not found')

        error_message = "Couldn't find User with 'id'=#{invalid_id}"
        expect(json.dig('message')).to eq(error_message)
      end
    end
  end

  describe 'GET #show' do
    context 'with valid User Id' do
      it 'returns a success response' do
        user = create(:user)
        get "#{api_path}/#{user.id}", params: {}, headers: headers

        expect(response).to have_http_status(:success)
        expect(response).to be_successful
      end
    end

    context 'with invalid User Id' do
      it 'renders a JSON response with not found error' do
        put "#{api_path}/#{invalid_id}", params: {}, headers: headers

        expect(response).to have_http_status(:not_found)
        expect(response.content_type).to eq('application/vnd.api+json')
        expect(json.dig('error')).to eq('Not found')

        error_message = "Couldn't find User with 'id'=#{invalid_id}"
        expect(json.dig('message')).to eq(error_message)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'with valid User Id' do
      it 'destroys the requested user' do
        user = create(:user)
        delete "#{api_path}/#{user.id}", params: {}, headers: headers

        expect(response).to have_http_status(204)
        expect(User.employees.size).to eq(0)
      end
    end

    context 'with invalid User Id' do
      it 'renders a JSON response with not found error' do
        put "#{api_path}/#{invalid_id}", params: {}, headers: headers

        expect(response).to have_http_status(:not_found)
        expect(response.content_type).to eq('application/vnd.api+json')
        expect(json.dig('error')).to eq('Not found')

        error_message = "Couldn't find User with 'id'=#{invalid_id}"
        expect(json.dig('message')).to eq(error_message)
      end
    end
  end
end
