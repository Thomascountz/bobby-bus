# frozen_string_literal: true

require './app/lib/mta_bus_info_client'

class MockHTTPClient
  attr_reader :fetch_calls

  def initialize
    @fetch_calls = []
    @fetch_response = ''
  end

  def fetch(endpoint, params = {})
    fetch_calls << { endpoint: endpoint, params: params }
    @fetch_response
  end

  def fetch_should_return(response)
    @fetch_response = response
  end

  private

  attr_writer :fetch_calls
end

RSpec.describe MTABusInfoClient do
  before(:each) do
    allow(ENV).to receive(:fetch).with('MTA_BUS_INFO_SERVICE_ENDPOINT').and_return('mta_bus_info_service_endpoint')
    allow(ENV).to receive(:fetch).with('MTA_BUS_INFO_SERVICE_VERSION').and_return('mta_bus_info_service_version')
    allow(ENV).to receive(:fetch).with('MTA_BUS_INFO_API_KEY').and_return('api_key')
  end

  describe '#fetch_stop_monitoring_info' do
    it 'makes a call to HTTPClient' do
      http_client = MockHTTPClient.new
      mta_bus_info_client = MTABusInfoClient.new(http_client: http_client)
      mta_bus_info_client.fetch_stop_monitoring(stop_code: '123456')
      expect(http_client.fetch_calls.count).to eq(1)
    end

    it 'makes a call to HTTPClient with an endpoint and query string' do
      http_client = MockHTTPClient.new
      mta_bus_info_client = MTABusInfoClient.new(http_client: http_client)
      mta_bus_info_client.fetch_stop_monitoring(stop_code: '123456')
      expect(http_client.fetch_calls.dig(0, :endpoint)).to eq('mta_bus_info_service_endpoint')
      expect(http_client.fetch_calls.dig(0, :params, :MonitoringRef)).to eq('123456')
      expect(http_client.fetch_calls.dig(0, :params, :version)).to eq('mta_bus_info_service_version')
      expect(http_client.fetch_calls.dig(0, :params, :key)).to eq('api_key')
    end

    it 'returns the response from HTTPClient' do
      http_client = MockHTTPClient.new
      http_client.fetch_should_return('fetch response')
      mta_bus_info_client = MTABusInfoClient.new(http_client: http_client)
      response = mta_bus_info_client.fetch_stop_monitoring(stop_code: '123456')
      expect(response).to eq('fetch response')
    end
  end
end
