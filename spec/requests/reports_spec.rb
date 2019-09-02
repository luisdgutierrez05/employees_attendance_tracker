# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Reports API', type: :request do
  let(:api_path) { '/api/v1/reports' }
  let!(:admin_user) { create(:user, :admin) }
  let!(:user) { create(:user) }

  let(:invalid_id) { '4a00e0eb-e00c-7d00-b000-11198250f200' }

  let!(:specific_date) do
    create(:entry, user_id: user.id,
                   checkin_at: checkin_at_last_week,
                   checkout_at: checkout_at_last_week)
  end

  let!(:entry_yesterday) do
    create(:entry,
           user_id: user.id,
           checkin_at: checkin_at_yesterday,
           checkout_at: checkout_at_yesterday)
  end

  let!(:entry_today) do
    create(:entry,
           user_id: user.id,
           checkin_at: checkin_at_today,
           checkout_at: checkout_at_today)
  end

  describe 'GET #index' do
    context 'as admin user' do
      let(:headers) { valid_headers(admin_user.id) }

      context 'when default query' do
        context 'and user has entries' do
          let(:params) { { user_id: user.id } }

          before do
            create_list(:entry, 3)
            create_list(:entry, 2, user_id: user.id)
          end

          it 'returns a list of entries' do
            get api_path, params: params, headers: headers

            expect(response).to have_http_status(:success)
            expect(response).to be_successful

            total_entries = json.dig('meta', 'total-count')
            expect(total_entries).to eq(5)
          end
        end

        context 'and user does not have entries' do
          let(:new_user) { create(:user) }
          let(:params) { { user_id: new_user.id } }

          it 'returns no entries' do
            get api_path, params: params, headers: headers

            expect(response).to have_http_status(:success)
            expect(response).to be_successful

            total_entries = json.dig('meta', 'total-count')
            expect(total_entries).to eq(0)
          end
        end
      end

      context 'when report per day' do
        context 'and specific date is valid' do
          let(:params) do
            { user_id: user.id, date: specific_date.checkin_at.to_date.to_s }
          end

          it 'returns a single entry' do
            get api_path, params: params, headers: headers

            expect(response).to have_http_status(:success)
            expect(response).to be_successful

            total_entries = json.dig('meta', 'total-count')
            expect(total_entries).to eq(1)
          end
        end

        context 'and specific date is invalid' do
          let(:params) do
            { user_id: user.id, date: 'invalid' }
          end

          it 'returns an error message' do
            get api_path, params: params, headers: headers

            expect(response.content_type).to eq('application/vnd.api+json')
            expect(json.dig('error')).to eq('Bad request')

            error_response = json.dig('message')
            error_message = I18n.t('exceptions.invalid_date')
            expect(error_response).to eq(error_message)
          end
        end

        context 'and period is today' do
          let(:params) { { user_id: user.id,  period: 'today' } }

          it 'returns a single entry' do
            get api_path, params: params, headers: headers

            expect(response).to have_http_status(:success)
            expect(response).to be_successful

            total_entries = json.dig('meta', 'total-count')
            expect(total_entries).to eq(1)
          end
        end

        context 'and period is yesterday' do
          let(:params) { { user_id: user.id, period: 'yesterday' } }

          it 'returns a single entry' do
            get api_path, params: params, headers: headers

            expect(response).to have_http_status(:success)
            expect(response).to be_successful

            total_entries = json.dig('meta', 'total-count')
            expect(total_entries).to eq(1)
          end
        end
      end

      context 'when report per week' do
        before do
          create_list(:entry, 2,
                      checkin_at: checkin_at_last_week,
                      checkout_at: checkout_at_last_week,
                      user_id: user.id)

          create_list(:entry, 2, user_id: user.id)
        end

        context 'and period is this week' do
          let(:params) { { user_id: user.id, period: 'thisweek' } }

          it 'returns entries from this week' do
            get api_path, params: params, headers: headers

            expect(response).to have_http_status(:success)
            expect(response).to be_successful

            total_entries = json.dig('meta', 'total-count')
            expect(total_entries).to eq(3)
          end
        end

        context 'and period is last week' do
          let(:params) { { user_id: user.id, period: 'lastweek' } }

          it 'returns entries from last week' do
            get api_path, params: params, headers: headers

            expect(response).to have_http_status(:success)
            expect(response).to be_successful

            total_entries = json.dig('meta', 'total-count')
            expect(total_entries).to eq(4)
          end
        end
      end

      context 'when report per month' do
        before do
          create_list(:entry, 2,
                      checkin_at: checkin_at_last_month,
                      checkout_at: checkout_at_last_month,
                      user_id: user.id)

          create_list(:entry, 2, user_id: user.id)
        end

        context 'and period is this month' do
          let(:params) { { user_id: user.id, period: 'thismonth' } }

          it 'returns entries from this month' do
            get api_path, params: params, headers: headers

            expect(response).to have_http_status(:success)
            expect(response).to be_successful

            total_entries = json.dig('meta', 'total-count')
            expect(total_entries).to eq(4)
          end
        end

        context 'and period is last month' do
          let(:params) { { user_id: user.id, period: 'lastmonth' } }

          it 'returns entries from last month' do
            get api_path, params: params, headers: headers

            expect(response).to have_http_status(:success)
            expect(response).to be_successful

            total_entries = json.dig('meta', 'total-count')
            expect(total_entries).to eq(3)
          end
        end
      end

      context 'when report per year' do
        before do
          create(:entry,
                 checkin_at: checkin_at_last_year,
                 checkout_at: checkout_at_last_year,
                 user_id: user.id)

          create(:entry, user_id: user.id)
        end

        context 'and period is this year' do
          let(:params) { { user_id: user.id, period: 'thisyear' } }

          it 'returns entries from this year' do
            get api_path, params: params, headers: headers

            expect(response).to have_http_status(:success)
            expect(response).to be_successful

            total_entries = json.dig('meta', 'total-count')
            expect(total_entries).to eq(4)
          end
        end

        context 'and period is last year' do
          let(:params) { { user_id: user.id, period: 'lastyear' } }

          it 'returns entries from last year' do
            get api_path, params: params, headers: headers

            expect(response).to have_http_status(:success)
            expect(response).to be_successful

            total_entries = json.dig('meta', 'total-count')
            expect(total_entries).to eq(1)
          end
        end
      end

      context 'when invalid user id' do
        let(:params) { { user_id: invalid_id } }

        it 'returns an error message' do
          get api_path, params: params, headers: headers

          expect(response.content_type).to eq('application/vnd.api+json')
          expect(json.dig('error')).to eq('Bad request')

          error_response = json.dig('message')
          error_message = I18n.t('exceptions.invalid_user_id')
          expect(error_response).to eq(error_message)
        end
      end

      context 'when period is invalid' do
        let(:params) { { user_id: user.id, period: 'invalid' } }

        it 'returns an error message' do
          get api_path, params: params, headers: headers

          expect(response.content_type).to eq('application/vnd.api+json')
          expect(json.dig('error')).to eq('Bad request')

          error_response = json.dig('message')
          error_message = I18n.t('exceptions.invalid_period_name')
          expect(error_response).to eq(error_message)
        end
      end
    end

    context 'as employee' do
      let(:headers) { valid_headers(user.id) }

      context 'when report per day' do
        context 'and specific date is valid' do
          let(:params) { { date: specific_date.checkin_at.to_date.to_s } }

          it 'returns a single entry' do
            get api_path, params: params, headers: headers

            expect(response).to have_http_status(:success)
            expect(response).to be_successful

            total_entries = json.dig('meta', 'total-count')
            expect(total_entries).to eq(1)
          end
        end

        context 'and specific date is invalid' do
          let(:params) { { date: 'invalid' } }

          it 'returns an error message' do
            get api_path, params: params, headers: headers

            expect(response.content_type).to eq('application/vnd.api+json')
            expect(json.dig('error')).to eq('Bad request')

            error_response = json.dig('message')
            error_message = I18n.t('exceptions.invalid_date')
            expect(error_response).to eq(error_message)
          end
        end

        context 'and period is today' do
          let(:params) { { period: 'today' } }

          it 'returns a single entry' do
            get api_path, params: params, headers: headers

            expect(response).to have_http_status(:success)
            expect(response).to be_successful

            total_entries = json.dig('meta', 'total-count')
            expect(total_entries).to eq(1)
          end
        end

        context 'and period is yesterday' do
          let(:params) { { period: 'yesterday' } }

          it 'returns a single entry' do
            get api_path, params: params, headers: headers

            expect(response).to have_http_status(:success)
            expect(response).to be_successful

            total_entries = json.dig('meta', 'total-count')
            expect(total_entries).to eq(1)
          end
        end
      end

      context 'when permission denied' do
        let(:params) { { period: 'thisweek' } }

        it 'returns an error message' do
          get api_path, params: params, headers: headers

          expect(response.content_type).to eq('application/vnd.api+json')
          expect(json.dig('error')).to eq('Not Permitted')

          error_response = json.dig('message')
          error_message = I18n.t('exceptions.permission_denied')
          expect(error_response).to eq(error_message)
        end
      end
    end
  end
end
