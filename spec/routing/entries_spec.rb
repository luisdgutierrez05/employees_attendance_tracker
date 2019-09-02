# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::EntriesController, type: :routing do
  describe 'routing' do
    let(:id) { '219ad6c2-19de-42c9-8133-0d03f2523653' }
    let(:format) { 'json' }
    let(:path) { 'api/v1/entries' }

    it 'routes to #index' do
      expect(get: path).to route_to("#{path}#index", format: format)
    end

    it 'routes to #show' do
      expect(get: "#{path}/#{id}").to route_to("#{path}#show", id: id, format: format)
    end

    it 'routes to #create' do
      expect(post: path).to route_to("#{path}#create", format: format)
    end

    it 'routes to #update via PUT' do
      expect(put: "#{path}/#{id}").to route_to("#{path}#update", id: id, format: format)
    end

    it 'routes to #update via PATCH' do
      expect(patch: "#{path}/#{id}").to route_to("#{path}#update", id: id, format: format)
    end

    it 'routes to #destroy' do
      expect(delete: "#{path}/#{id}").to route_to("#{path}#destroy", id: id, format: format)
    end
  end
end
