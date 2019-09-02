# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReportsService do
  let!(:user) { create(:user) }
  let!(:query_params) { { user_id: user.id } }

  subject { described_class.new(nil, query_params) }

  describe '#perform' do
    context 'when default query' do
      context 'and user has entries' do
        before do
          create_list(:entry, 2)
          create_list(:entry, 3, user_id: user.id)
        end

        it 'returns a list of entries by User Id' do
          results = subject.perform

          expect(results.size).to eq(3)
        end
      end

      context 'and user does not have entries' do
        it 'returns a empty response' do
          results = subject.perform

          expect(results.size).to eq(0)
        end
      end

      context 'and user_id is invalid' do
        let(:query_params) { { user_id: 'invalid' } }

        it 'raises CustomExceptions::InvalidRequestError error' do
          exception = CustomExceptions::InvalidRequestError
          error_message = I18n.t('exceptions.invalid_user_id')

          expect do
            subject.perform
          end.to raise_error exception, error_message
        end
      end
    end

    context 'when report per day' do
      let!(:specific_date) do
        create(:entry,
               user_id: user.id,
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

      context 'and specific day' do
        let(:date) { specific_date.checkin_at.to_date.to_s }
        let(:query_params) { { user_id: user.id, date: date } }

        it 'returns a specific entry' do
          results = subject.perform

          expect(results.size).to eq(1)
        end
      end

      context 'and period is today' do
        let(:query_params) { { user_id: user.id, period: 'today' } }

        it 'returns a specific entry' do
          results = subject.perform

          expect(results.size).to eq(1)
        end
      end

      context 'and period is yesterday' do
        let(:query_params) { { user_id: user.id, period: 'yesterday' } }

        it 'returns a specific entry' do
          results = subject.perform

          expect(results.size).to eq(1)
        end
      end
    end

    context 'when report per week' do
      before do
        create_list(:entry, 2,
                    checkin_at: checkin_at_last_week,
                    checkout_at: checkout_at_last_week,
                    user_id: user.id)

        create_list(:entry, 3, user_id: user.id)
      end

      context 'and period is this week' do
        let(:query_params) { { user_id: user.id, period: 'thisweek' } }

        it 'returns entries from this week' do
          results = subject.perform

          expect(results.size).to eq(3)
        end
      end

      context 'and period is last week' do
        let(:query_params) { { user_id: user.id, period: 'lastweek' } }

        it 'returns entries from last week' do
          results = subject.perform

          expect(results.size).to eq(2)
        end
      end
    end

    context 'when report per month' do
      before do
        create_list(:entry, 2,
                    checkin_at: checkin_at_last_month,
                    checkout_at: checkout_at_last_month,
                    user_id: user.id)

        create_list(:entry, 3, user_id: user.id)
      end

      context 'and period is this month' do
        let(:query_params) { { user_id: user.id, period: 'thismonth' } }

        it 'returns entries from this month' do
          results = subject.perform

          expect(results.size).to eq(3)
        end
      end

      context 'and period is last month' do
        let(:query_params) { { user_id: user.id, period: 'lastmonth' } }

        it 'returns entries from last month' do
          results = subject.perform

          expect(results.size).to eq(2)
        end
      end
    end

    context 'when report per year' do
      before do
        create_list(:entry, 2,
                    checkin_at: checkin_at_last_year,
                    checkout_at: checkout_at_last_year,
                    user_id: user.id)

        create_list(:entry, 3, user_id: user.id)
      end

      context 'and period is this year' do
        let(:query_params) { { user_id: user.id, period: 'thisyear' } }

        it 'returns entries from this year' do
          results = subject.perform

          expect(results.size).to eq(3)
        end
      end

      context 'and period is last year' do
        let(:query_params) { { user_id: user.id, period: 'lastyear' } }

        it 'returns entries from last year' do
          results = subject.perform

          expect(results.size).to eq(2)
        end
      end
    end

    context 'when period is invalid' do
      let(:query_params) { { user_id: user.id, period: 'invalid' } }

      it 'raises CustomExceptions::InvalidRequestError error' do
        exception = CustomExceptions::InvalidRequestError
        error_message = I18n.t('exceptions.invalid_period_name')

        expect do
          subject.perform
        end.to raise_error exception, error_message
      end
    end
  end
end
