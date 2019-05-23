# frozen_string_literal: true

require './app/lib/stop_monitor_presenter'
require 'date'

RSpec.describe StopMonitorPresenter do
  describe '#stop_name' do
    it 'formats the stop name' do
      examples = [
        { raw: 'DITMARS BL/42 ST', presented: 'Ditmars & 42' },
        { raw: 'HENDERSON AV/WESTBURY AV', presented: 'Henderson & Westbury' },
        { raw: 'BROADWAY/WAVERLY PL', presented: 'Broadway & Waverly' },
        { raw: 'FT WASHINGTON AV/W 187 ST', presented: 'Ft Washington & W 187' },
        { raw: 'MANOR RD/N GANNON AV', presented: 'Manor & N Gannon' },
        { raw: 'GUY R BREWER BL /119 AV', presented: 'Guy R Brewer & 119' },
        { raw: 'MARCONI ST/LA FITNESS ENT', presented: 'Marconi & La Fitness' }
      ]
      examples.each do |example|
        stop_monitor = StopMonitor.new(stop_name: example[:raw])
        stop_monitor_presenter = StopMonitorPresenter.new(stop_monitor: stop_monitor)
        expect(stop_monitor_presenter.stop_name).to eq(example[:presented])
      end
    end
  end

  describe '#line_name' do
    it 'formats the line name' do
      stop_visits = [
        StopVisit.new(line_name: 'Q69'),
        StopVisit.new(line_name: 'S44'),
        StopVisit.new(line_name: 'B32')
      ]
      stop_monitor = StopMonitor.new(stop_visits: stop_visits)
      stop_monitor_presenter = StopMonitorPresenter.new(stop_monitor: stop_monitor)
      expect(stop_monitor_presenter.routes.keys).to include('Q69')
      expect(stop_monitor_presenter.routes.keys).to include('S44')
      expect(stop_monitor_presenter.routes.keys).to include('B32')
    end
  end

  describe '#proximity_text' do
    it 'formats the proximity text' do
      response_timestamp = DateTime.new(2000, 1, 1, 0, 0, 0, 'EST')
      stop_visits = [
        StopVisit.new(line_name: 'Q66', proximity_text: 'approaching', arrival_time: DateTime.new(2000, 1, 1, 0, 0, 0, 'EST')),
        StopVisit.new(line_name: 'Q66', proximity_text: '2 stops', arrival_time: DateTime.new(2000, 1, 1, 0, 5, 0, 'EST')),
        StopVisit.new(line_name: 'Q66', proximity_text: '1.2 miles away', arrival_time: DateTime.new(2000, 1, 1, 1, 0, 0, 'EST')),
        StopVisit.new(line_name: 'Q66', proximity_text: '2.3 miles away')
      ]
      stop_monitor = StopMonitor.new(stop_visits: stop_visits, response_timestamp: response_timestamp)
      stop_monitor_presenter = StopMonitorPresenter.new(stop_monitor: stop_monitor)
      expect(stop_monitor_presenter.routes.dig('Q66', 0).description).to eq('0 min / approaching')
      expect(stop_monitor_presenter.routes.dig('Q66', 1).description).to eq('5 min / 2 stops')
      expect(stop_monitor_presenter.routes.dig('Q66', 2).description).to eq('60 min / 1.2 mi')
      expect(stop_monitor_presenter.routes.dig('Q66', 3).description).to eq('2.3 mi')
    end
  end
end
