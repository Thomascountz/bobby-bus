# frozen_string_literal: true

require_relative './http_client'

class MTABusInfoClient
  def initialize(http_client: HTTPClient.new)
    @http_client = http_client
  end

  def fetch_stop_monitoring(stop_code:)
    params = { "MonitoringRef": stop_code,
               "version": version,
               "key": key }
    http_client.fetch(endpoint, params)
  end

  private

  attr_reader :http_client

  def endpoint
    ENV.fetch('MTA_BUS_INFO_SERVICE_ENDPOINT')
  end

  def version
    ENV.fetch('MTA_BUS_INFO_SERVICE_VERSION')
  end

  def key
    ENV.fetch('MTA_BUS_INFO_API_KEY')
  end
end
