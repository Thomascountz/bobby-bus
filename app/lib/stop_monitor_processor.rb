# frozen_string_literal: true

require 'active_support'
require_relative './stop_monitor'
require_relative './stop_visit'

class StopMonitorProcessor
  class << self
    def process(json:)
      parsed_json = ActiveSupport::JSON.decode(json)
      monitored_stop_visits = parsed_json.dig('Siri', 'ServiceDelivery', 'StopMonitoringDelivery', 0, 'MonitoredStopVisit')

      if monitored_stop_visits == nil
        return StopMonitor.new()
      end

      stop_name = monitored_stop_visits.dig(0, 'MonitoredVehicleJourney', 'MonitoredCall', 'StopPointName', 0)
      stop_visits = monitored_stop_visits.map do |stop_visit|
        StopVisit.new(
          line_name: stop_visit.dig('MonitoredVehicleJourney', 'PublishedLineName', 0),
          arrival_time: DateTime.parse(stop_visit.dig('MonitoredVehicleJourney', 'MonitoredCall', 'ExpectedArrivalTime')),
          proximity_text: stop_visit.dig('MonitoredVehicleJourney', 'MonitoredCall', 'ArrivalProximityText'),
          no_of_stops_away: stop_visit.dig('MonitoredVehicleJourney', 'MonitoredCall', 'NumberOfStopsAway')
        )
      end

      StopMonitor.new(stop_name: stop_name,
                      stop_visits: stop_visits)
    end
  end
end
