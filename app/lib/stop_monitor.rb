# frozen_string_literal: true

require_relative './stop_visit'

class StopMonitor
  attr_reader :response_timestamp, :stop_code, :stop_name, :stop_visits, :error_description
  def initialize(response_timestamp: nil,
                 stop_code: nil,
                 stop_name: nil,
                 stop_visits: nil,
                 error_description: nil)
    @response_timestamp = response_timestamp
    @stop_code = stop_code
    @stop_name = stop_name
    @stop_visits = stop_visits
    @error_description = error_description
  end
end
