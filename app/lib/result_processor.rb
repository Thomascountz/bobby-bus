require 'active_support'

class ResultProcessor
  class << self
    def process(json:)
      parsed_json = ActiveSupport::JSON.decode(json)
      stop_name = parsed_json["Siri"]["ServiceDelivery"]["StopMonitoringDelivery"][0]["MonitoredStopVisit"][0]["MonitoredVehicleJourney"]["MonitoredCall"]["StopPointName"][0]
      Result.new(stop_name: stop_name)
    end
  end
end

class Result
  attr_reader :stop_name
  def initialize(stop_name: "")
    @stop_name = stop_name
  end
end
