# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FilterEntriesService do
  let!(:user) { create(:user) }

  subject(:without_filters) { described_class.new({}) }
  subject(:with_user_id_filter) { described_class.new({ user_id: user.id }) }
  subject(:with_email_filter) { described_class.new({ email: user.email }) }

  before do
    create_list(:entry, 2)
    create_list(:entry, 3, user_id: user.id)
  end

  describe '#perform' do
    context 'when no filters' do
      it 'returns a list of entries' do
        results = without_filters.perform

        expect(results.size).to eq(5)
      end
    end

    context 'when filter by user_id' do
      it 'returns a list of entries' do
        results = with_user_id_filter.perform

        expect(results.size).to eq(3)
      end
    end

    context 'when filter by email' do
      it 'returns a list of entries' do
        results = with_email_filter.perform

        expect(results.size).to eq(3)
      end
    end

    context 'when page param is invalid' do
      it 'raises CustomExceptions::ExpiredSignature error' do
        error_message = I18n.t('exceptions.invalid_page_number')
        expect do
          described_class.new({ page: 'invalid page' }).perform
        end.to raise_error CustomExceptions::InvalidRequestError, error_message
      end
    end
  end
end
