# frozen_string_literal: true

require 'active_support'
require_relative './stop_monitor'
require_relative './stop_visit'

class StopMonitorProcessor
  class << self
    def process(json:)
      begin
        parsed_json = ActiveSupport::JSON.decode(json)
      rescue JSON::ParserError
        return StopMonitor.new
      end

      monitored_stop_visits = parsed_json.dig('Siri', 'ServiceDelivery', 'StopMonitoringDelivery', 0, 'MonitoredStopVisit')

      return StopMonitor.new if monitored_stop_visits.nil?

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

      StopMonitor.new(stop_code: stop_code,
                      stop_name: stop_name,
                      stop_visits: stop_visits)
    end
  end
end
