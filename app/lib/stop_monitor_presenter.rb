# frozen_string_literal: true

require 'date'
require 'active_support/inflector'
require_relative './stop_monitor'

class StopMonitorPresenter
  attr_reader :stop_visits, :routes

  def initialize(stop_monitor:)
    @stop_monitor = stop_monitor
    if stop_monitor.stop_visits
      @routes = stop_monitor.stop_visits.map do |stop_visit|
        Route.new(stop_visit: stop_visit,
                  response_timestamp: stop_monitor.response_timestamp)
      end.group_by(&:line_name)
    end
  end

  def stop_name
    stop_monitor.stop_name.split('/').map do |street|
      if street.include?(' ')
        street.split(' ')[0...-1].join(' ').titleize
      else
        street.titleize
      end
    end.join(' & ')
  end

  private

  attr_reader :stop_monitor
end

class Route
  def initialize(stop_visit:, response_timestamp: nil)
    @stop_visit = stop_visit
    @response_timestamp = response_timestamp
  end

  def line_name
    stop_visit.line_name&.upcase
  end

  def description
    if time_until_arrival_text
      "#{time_until_arrival_text} / #{proximity_text}"
    else
      proximity_text.to_s
    end
  end

  private

  def proximity_text
    stop_visit.proximity_text.gsub('miles away', 'mi')
  end

  def time_until_arrival_text
    if stop_visit.arrival_time && response_timestamp
      "#{((stop_visit.arrival_time - response_timestamp) * 24 * 60).to_i} min"
    end
  end

  attr_reader :stop_visit, :response_timestamp
end
