# frozen_string_literal: true

class StopVisit
  attr_reader :line_name, :arrival_time, :proximity_text, :no_of_stops_away
  def initialize(line_name: nil,
                 arrival_time: nil,
                 proximity_text: nil,
                 no_of_stops_away: nil)
    @line_name = line_name
    @arrival_time = arrival_time
    @proximity_text = proximity_text
    @no_of_stops_away = no_of_stops_away
  end
end
