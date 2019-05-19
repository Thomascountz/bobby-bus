# frozen_string_literal: true

require 'active_support'
require_relative './date_time_refinements'
require_relative './stop_monitor'
require_relative './stop_visit'

class StopMonitorProcessor
  class << self
    using DateTimeRefinements
    def process(json:)
      begin
        parsed_json = ActiveSupport::JSON.decode(json)
      rescue JSON::ParserError
        return StopMonitor.new
      end

      response_timestamp = DateTime.try_parse(parsed_json.dig('Siri', 'ServiceDelivery', 'ResponseTimestamp'))

      monitored_stop_visits = parsed_json.dig('Siri', 'ServiceDelivery', 'StopMonitoringDelivery', 0, 'MonitoredStopVisit')
      error_description = parsed_json.dig('Siri', 'ServiceDelivery', 'StopMonitoringDelivery', 0, 'ErrorCondition', 'Description')

      if monitored_stop_visits.nil?
        return StopMonitor.new(response_timestamp: response_timestamp,
                               error_description: error_description)
      end

      stop_code = monitored_stop_visits.dig(0, 'MonitoredVehicleJourney', 'MonitoredCall', 'StopPointRef')
      stop_name = monitored_stop_visits.dig(0, 'MonitoredVehicleJourney', 'MonitoredCall', 'StopPointName', 0)
      stop_visits = monitored_stop_visits.map do |stop_visit|
        StopVisit.new(
          line_name: stop_visit.dig('MonitoredVehicleJourney', 'PublishedLineName', 0),
          arrival_time: DateTime.parse(stop_visit.dig('MonitoredVehicleJourney', 'MonitoredCall', 'ExpectedArrivalTime')),
          proximity_text: stop_visit.dig('MonitoredVehicleJourney', 'MonitoredCall', 'ArrivalProximityText'),
          no_of_stops_away: stop_visit.dig('MonitoredVehicleJourney', 'MonitoredCall', 'NumberOfStopsAway')
        )
      end

      StopMonitor.new(response_timestamp: response_timestamp,
                      stop_code: stop_code,
                      stop_name: stop_name,
                      stop_visits: stop_visits,
                      error_description: error_description)
    end
  end
end
