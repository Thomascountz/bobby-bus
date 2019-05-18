# frozen_string_literal: true

require_relative './stop_visit'

class StopMonitor
  attr_reader :stop_name, :stop_visits
  def initialize(stop_name: nil,
                 stop_visits: nil)
    @stop_name = stop_name
    @stop_visits = stop_visits
  end
end
