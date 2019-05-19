# frozen_string_literal: true

require './app/lib/stop_monitor_processor'

RSpec.describe StopMonitorProcessor do
  describe '.process' do
    it 'turns json into a result object' do
      json = '{ "Siri": { "ServiceDelivery": { "ResponseTimestamp": "2019-05-18T14:48:25.312-04:00", "StopMonitoringDelivery": [ { "MonitoredStopVisit": [ { "MonitoredVehicleJourney": { "LineRef": "MTA NYCT_S44", "DirectionRef": "1", "FramedVehicleJourneyRef": { "DataFrameRef": "2019-05-18", "DatedVehicleJourneyRef": "MTA NYCT_YU_B9-Saturday-088500_S4494_11" }, "JourneyPatternRef": "MTA_S440226", "PublishedLineName": [ "S44" ], "OperatorRef": "MTA NYCT", "OriginRef": "MTA_202569", "DestinationRef": "MTA_203831", "DestinationName": [ "S I MALL YUKON AV" ], "SituationRef": [], "Monitored": true, "VehicleLocation": { "Longitude": -74.08208, "Latitude": 40.647561 }, "Bearing": 169.54008, "ProgressRate": "normalProgress", "BlockRef": "MTA NYCT_YU_B9-Saturday_A_YU_40920_S4494-11", "VehicleRef": "MTA NYCT_4054", "MonitoredCall": { "ExpectedArrivalTime": "2019-05-18T14:56:40.196-04:00", "ArrivalProximityText": "1.6 miles away", "ExpectedDepartureTime": "2019-05-18T14:56:40.196-04:00", "DistanceFromStop": 2521, "NumberOfStopsAway": 10, "StopPointRef": "MTA_200884", "VisitNumber": 1, "StopPointName": [ "HENDERSON AV/WESTBURY AV" ] } }, "RecordedAtTime": "2019-05-18T14:48:20.000-04:00" } ], "ResponseTimestamp": "2019-05-18T14:48:25.312-04:00", "ValidUntil": "2019-05-18T14:49:25.312-04:00" } ], "SituationExchangeDelivery": [] } } }'
      stop_monitor = StopMonitorProcessor.process(json: json)
      expect(stop_monitor.stop_name).to eq('HENDERSON AV/WESTBURY AV')
      expect(stop_monitor.stop_code).to eq('MTA_200884')
      expect(stop_monitor.stop_visits[0].line_name).to eq('S44')
      expect(stop_monitor.stop_visits[0].arrival_time.hour).to eq(14)
      expect(stop_monitor.stop_visits[0].arrival_time.minute).to eq(56)
      expect(stop_monitor.stop_visits[0].proximity_text).to eq('1.6 miles away')
      expect(stop_monitor.stop_visits[0].no_of_stops_away).to eq(10)
    end

    it 'maps two bus lines for one stop' do
      json = '{ "Siri": { "ServiceDelivery": { "ResponseTimestamp": "2019-05-18T18:26:35.459-04:00", "StopMonitoringDelivery": [ { "MonitoredStopVisit": [ { "MonitoredVehicleJourney": { "LineRef": "MTA NYCT_B62", "DirectionRef": "0", "FramedVehicleJourneyRef": { "DataFrameRef": "2019-05-18", "DatedVehicleJourneyRef": "MTA NYCT_GA_B9-Saturday-105800_B62_514" }, "JourneyPatternRef": "MTA_B620043", "PublishedLineName": [ "B62" ], "OperatorRef": "MTA NYCT", "OriginRef": "MTA_307997", "DestinationRef": "MTA_504549", "DestinationName": [ "LI CITY QUEENS PLAZA" ], "SituationRef": [ { "SituationSimpleRef": "MTA NYCT_1d55cc3d-cf1b-49d5-a6e9-2831831ea6e2" } ], "Monitored": true, "VehicleLocation": { "Longitude": -73.954166, "Latitude": 40.730019 }, "Bearing": 111.09234, "ProgressRate": "normalProgress", "BlockRef": "MTA NYCT_GA_B9-Saturday_A_GA_48900_B62-514", "VehicleRef": "MTA NYCT_4427", "MonitoredCall": { "ExpectedArrivalTime": "2019-05-18T18:26:49.666-04:00", "ArrivalProximityText": "approaching", "ExpectedDepartureTime": "2019-05-18T18:26:49.666-04:00", "DistanceFromStop": 57, "NumberOfStopsAway": 0, "StopPointRef": "MTA_305159", "VisitNumber": 1, "StopPointName": [ "MANHATTAN AV/GREENPOINT AV" ] } }, "RecordedAtTime": "2019-05-18T18:26:30.000-04:00" }, { "MonitoredVehicleJourney": { "LineRef": "MTA NYCT_B43", "DirectionRef": "0", "FramedVehicleJourneyRef": { "DataFrameRef": "2019-05-18", "DatedVehicleJourneyRef": "MTA NYCT_JG_B9-Saturday-103000_B43_118" }, "JourneyPatternRef": "MTA_B430059", "PublishedLineName": [ "B43" ], "OperatorRef": "MTA NYCT", "OriginRef": "MTA_308074", "DestinationRef": "MTA_305286", "DestinationName": [ "GREENPOINT BOX ST" ], "SituationRef": [ { "SituationSimpleRef": "MTA NYCT_228461" } ], "Monitored": true, "VehicleLocation": { "Longitude": -73.947247, "Latitude": 40.722196 }, "Bearing": 113.83874, "ProgressRate": "normalProgress", "BlockRef": "MTA NYCT_JG_B9-Saturday_A_JG_52080_B43-118", "VehicleRef": "MTA NYCT_663", "MonitoredCall": { "ExpectedArrivalTime": "2019-05-18T18:33:24.144-04:00", "ArrivalProximityText": "0.8 miles away", "ExpectedDepartureTime": "2019-05-18T18:33:24.144-04:00", "DistanceFromStop": 1280, "NumberOfStopsAway": 6, "StopPointRef": "MTA_305159", "VisitNumber": 1, "StopPointName": [ "MANHATTAN AV/GREENPOINT AV" ] } }, "RecordedAtTime": "2019-05-18T18:26:33.000-04:00" } ], "ResponseTimestamp": "2019-05-18T18:26:35.459-04:00", "ValidUntil": "2019-05-18T18:27:35.459-04:00" } ], "SituationExchangeDelivery": [] } } }'
      stop_monitor = StopMonitorProcessor.process(json: json)
      expect(stop_monitor.stop_name).to eq('MANHATTAN AV/GREENPOINT AV')
      expect(stop_monitor.stop_code).to eq('MTA_305159')
      expect(stop_monitor.stop_visits[0].line_name).to eq('B62')
      expect(stop_monitor.stop_visits[0].arrival_time.hour).to eq(18)
      expect(stop_monitor.stop_visits[0].arrival_time.minute).to eq(26)
      expect(stop_monitor.stop_visits[0].proximity_text).to eq('approaching')
      expect(stop_monitor.stop_visits[0].no_of_stops_away).to eq(0)
      expect(stop_monitor.stop_visits[1].line_name).to eq('B43')
      expect(stop_monitor.stop_visits[1].arrival_time.hour).to eq(18)
      expect(stop_monitor.stop_visits[1].arrival_time.minute).to eq(33)
      expect(stop_monitor.stop_visits[1].proximity_text).to eq('0.8 miles away')
      expect(stop_monitor.stop_visits[1].no_of_stops_away).to eq(6)
    end

    it 'can parse garbage json without blowing up' do
      json = '{}'
      stop_monitor = StopMonitorProcessor.process(json: json)
      expect(stop_monitor.stop_name).to eq(nil)
      expect(stop_monitor.stop_visits).to eq(nil)
    end

    it 'can parse garbage without blowing up' do
      json = 'literal trash'
      stop_monitor = StopMonitorProcessor.process(json: json)
      expect(stop_monitor.stop_name).to eq(nil)
      expect(stop_monitor.stop_visits).to eq(nil)
    end
  end
end
