# frozen_string_literal: true

require './app/lib/date_time_refinements'

RSpec.describe DateTimeRefinements do
  using DateTimeRefinements
  describe 'DateTime.try_parse' do
    it 'parses a string into a Datetime' do
      date_time_string = '2019-05-18T14:48:25.312-04:00'
      expect(DateTime.try_parse(date_time_string)).to eq(DateTime.parse(date_time_string))
    end

    it 'returns nil if the date time string cannot be parsed' do
      date_time_string = 'not a date time'
      expect(DateTime.try_parse(date_time_string)).to eq(nil)
    end

    it 'returns nil if the date time string is nil' do
      date_time_string = nil
      expect(DateTime.try_parse(date_time_string)).to eq(nil)
    end
  end
end
