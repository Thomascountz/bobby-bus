require './app/lib/result_processor'

RSpec.describe ResultProcessor do
  describe ".process" do
    it "turns json into a result object" do
      json = "{ \"Siri\": { \"ServiceDelivery\": { \"ResponseTimestamp\": \"2019-05-18T14:48:25.312-04:00\", \"StopMonitoringDelivery\": [ { \"MonitoredStopVisit\": [ { \"MonitoredVehicleJourney\": { \"LineRef\": \"MTA NYCT_S44\", \"DirectionRef\": \"1\", \"FramedVehicleJourneyRef\": { \"DataFrameRef\": \"2019-05-18\", \"DatedVehicleJourneyRef\": \"MTA NYCT_YU_B9-Saturday-088500_S4494_11\" }, \"JourneyPatternRef\": \"MTA_S440226\", \"PublishedLineName\": [ \"S44\" ], \"OperatorRef\": \"MTA NYCT\", \"OriginRef\": \"MTA_202569\", \"DestinationRef\": \"MTA_203831\", \"DestinationName\": [ \"S I MALL YUKON AV\" ], \"SituationRef\": [], \"Monitored\": true, \"VehicleLocation\": { \"Longitude\": -74.08208, \"Latitude\": 40.647561 }, \"Bearing\": 169.54008, \"ProgressRate\": \"normalProgress\", \"BlockRef\": \"MTA NYCT_YU_B9-Saturday_A_YU_40920_S4494-11\", \"VehicleRef\": \"MTA NYCT_4054\", \"MonitoredCall\": { \"ExpectedArrivalTime\": \"2019-05-18T14:56:40.196-04:00\", \"ArrivalProximityText\": \"1.6 miles away\", \"ExpectedDepartureTime\": \"2019-05-18T14:56:40.196-04:00\", \"DistanceFromStop\": 2521, \"NumberOfStopsAway\": 10, \"StopPointRef\": \"MTA_200884\", \"VisitNumber\": 1, \"StopPointName\": [ \"HENDERSON AV/WESTBURY AV\" ] } }, \"RecordedAtTime\": \"2019-05-18T14:48:20.000-04:00\" } ], \"ResponseTimestamp\": \"2019-05-18T14:48:25.312-04:00\", \"ValidUntil\": \"2019-05-18T14:49:25.312-04:00\" } ], \"SituationExchangeDelivery\": [] } } }"
      result = ResultProcessor.process(json: json)
      expect(result.stop_name).to eq("HENDERSON AV/WESTBURY AV")
    end
  end
end
