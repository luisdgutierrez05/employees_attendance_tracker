# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Entries API', type: :request do
  let(:api_path) { '/api/v1/entries' }
  let!(:admin_user) { create(:user, :admin) }
  let!(:user) { create(:user) }
  let(:headers) { valid_headers(admin_user.id) }

  let(:valid_attributes) do
    {
      checkin_at: '2019-08-28 09:00:01',
      user_id: user.id,
      observation: 'none'
    }
  end

  let(:invalid_attributes) do
    {
      checkin_at: nil,
      checkout_at: nil,
      user_id: nil,
      observation: nil
    }
  end

  let(:invalid_id) { '4a00e0eb-e00c-7d00-b000-11198250f200' }

  describe 'GET #index' do
    before :each do
      create_list(:entry, 3)
    end

    context 'when no filters' do
      it 'returns a list of entries' do
        get api_path, params: {}, headers: headers

        expect(response).to have_http_status(:success)
        expect(response).to be_successful
      end
    end

    context 'when filter by user_id' do
      it 'returns a list of entries' do
        create_list(:entry, 3, user_id: user.id)
        get "#{api_path}?user_id=#{user.id}", params: {}, headers: headers

        expect(response).to have_http_status(:success)
        expect(response).to be_successful

        total_entries = json.dig('meta', 'total-count')
        expect(total_entries).to eq(3)
      end
    end

    context 'when filter by email' do
      it 'returns a list of entries' do
        create_list(:entry, 4, user_id: user.id)
        get "#{api_path}?email=#{user.email}", params: {}, headers: headers

        expect(response).to have_http_status(:success)
        expect(response).to be_successful

        total_entries = json.dig('meta', 'total-count')
        expect(total_entries).to eq(4)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      let(:entry_attributes) do
        {
          data: {
            attributes: valid_attributes
          }
        }.to_json
      end

      it 'creates a new Entry' do
        post api_path, params: entry_attributes, headers: headers

        expect(response).to have_http_status(201)
        expect(response.content_type).to eq('application/vnd.api+json')
        expect(Entry.count).to eq(1)

        attributes = json&.dig('data', 'attributes')
        expect(attributes['checkin-at']).to eq('08-28-2019 09:00:01 AM')
        expect(attributes['user-id']).to eq(user.id)
      end
    end

    context 'with invalid params' do
      context 'and invalid User Id' do
        let(:entry_attributes) do
          {
            data: {
              attributes: invalid_attributes
            }
          }.to_json
        end

        it 'renders a JSON response ' do
          post api_path, params: entry_attributes, headers: headers

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/vnd.api+json')
          expect(json.dig('error')).to eq('Unprocessable entity')

          error_messages = "Validation failed: User must exist, Checkin at "\
                           "can't be blank, Checkin at must be a valid Date "\
                           "Time with format yyyy-mm-dd hh:mm:ss, User "\
                           "can't be blank"
          expect(json.dig('message')).to eq(error_messages)
        end
      end

      context 'and valid User Id' do
        let(:entry_attributes) do
          {
            data: {
              attributes: invalid_attributes.merge!(user_id: user.id)
            }
          }.to_json
        end

        it 'renders a JSON response with errors for the new entry' do
          post api_path, params: entry_attributes, headers: headers

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/vnd.api+json')
          expect(json.dig('error')).to eq('Unprocessable entity')

          error_messages = "Validation failed: Checkin at can't be blank, "\
                           "Checkin at must be a valid Date Time with "\
                           "format yyyy-mm-dd hh:mm:ss"
          expect(json.dig('message')).to eq(error_messages)
        end
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        {
          data: {
            type: 'entries',
            attributes: {
              checkout_at: '2019-08-28 18:02:00',
              observation: 'leave early'
            }
          }
        }.to_json
      end

      it 'updates the requested entry' do
        entry = create(:entry, user: user)
        put "#{api_path}/#{entry.id}", params: new_attributes, headers: headers

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/vnd.api+json')

        attributes = json&.dig('data', 'attributes')
        expect(attributes['checkout-at']).to eq('08-28-2019 18:02:00 PM')
        expect(attributes['observation']).to eq('leave early')
      end
    end

    context 'with invalid params' do
      let(:invalid_attributes) do
        {
          data: {
            type: 'entries',
            attributes: {
              checkin_at: nil,
              checkout_at: nil
            }
          }
        }.to_json
      end

      it 'returns a JSON response with validation errors' do
        entry = create(:entry, user: user)
        path = "#{api_path}/#{entry.id}"
        put path, params: invalid_attributes, headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/vnd.api+json')
        expect(json.dig('error')).to eq('Unprocessable entity')

        error_message = "Validation failed: Checkin at can't be blank, "\
                        "Checkin at must be a valid Date Time with "\
                        "format yyyy-mm-dd hh:mm:ss"
        expect(json['message']).to eq(error_message)
      end
    end

    context 'with invalid Entry Id' do
      it 'renders a JSON response with not found error' do
        put "#{api_path}/#{invalid_id}", params: {}, headers: headers

        expect(response).to have_http_status(:not_found)
        expect(response.content_type).to eq('application/vnd.api+json')
        expect(json.dig('error')).to eq('Not found')

        error_message = "Couldn't find Entry with 'id'=#{invalid_id}"
        expect(json.dig('message')).to eq(error_message)
      end
    end
  end

  describe 'GET #show' do
    context 'with valid Entry Id' do
      it 'returns a success response' do
        entry = create(:entry)
        get "#{api_path}/#{entry.id}", params: {}, headers: headers

        expect(response).to have_http_status(:success)
        expect(response).to be_successful
      end
    end

    context 'with invalid Entry Id' do
      it 'renders a JSON response with not found error' do
        put "#{api_path}/#{invalid_id}", params: {}, headers: headers

        expect(response).to have_http_status(:not_found)
        expect(response.content_type).to eq('application/vnd.api+json')
        expect(json.dig('error')).to eq('Not found')

        error_message = "Couldn't find Entry with 'id'=#{invalid_id}"
        expect(json.dig('message')).to eq(error_message)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'with valid Entry Id' do
      it 'destroys the requested entry' do
        entry = create(:entry)
        delete "#{api_path}/#{entry.id}", params: {}, headers: headers

        expect(response).to have_http_status(204)
        expect(Entry.count).to eq(0)
      end
    end

    context 'with invalid Entry Id' do
      it 'renders a JSON response with not found error' do
        put "#{api_path}/#{invalid_id}", params: {}, headers: headers

        expect(response).to have_http_status(:not_found)
        expect(response.content_type).to eq('application/vnd.api+json')
        expect(json.dig('error')).to eq('Not found')

        error_message = "Couldn't find Entry with 'id'=#{invalid_id}"
        expect(json.dig('message')).to eq(error_message)
      end
    end
  end
end
