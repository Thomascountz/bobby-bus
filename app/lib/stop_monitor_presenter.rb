# frozen_string_literal: true

require 'active_support/inflector'
require_relative './stop_monitor'

class StopMonitorPresenter
  attr_reader :stop_visits, :routes

  def initialize(stop_monitor:)
    @stop_monitor = stop_monitor
    if stop_monitor.stop_visits
      @routes = stop_monitor.stop_visits.map do |stop_visit|
        Route.new(stop_visit: stop_visit)
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
  def initialize(stop_visit:)
    @stop_visit = stop_visit
  end

  def line_name
    stop_visit.line_name&.upcase
  end

  def proximity_text
    stop_visit.proximity_text
  end

  private

  attr_reader :stop_visit
end
