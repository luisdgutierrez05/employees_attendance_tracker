# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::ReportsController, type: :routing do
  describe 'routing' do
    let(:path) { 'api/v1/reports' }

    it 'routes to #index' do
      expect(get: path).to route_to("#{path}#index", format: 'json')
    end
  end
end
