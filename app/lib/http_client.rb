# frozen_string_literal: true

require 'net/http'

class HTTPClient
  def fetch(endpoint, params = {})
    uri = URI(endpoint)
    uri.query = URI.encode_www_form(params)
    response = Net::HTTP.get_response(uri)
    response.body if response.is_a?(Net::HTTPSuccess)
  end
end
