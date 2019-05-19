# frozen_string_literal: true

class BobbyController < ApplicationController
  def index; end

  def search
    http_client = HTTPClient.new
    mta_bus_info_client = MTABusInfoClient.new(http_client: http_client)
    result = mta_bus_info_client.fetch_stop_monitoring(stop_code: params[:stop_id])
    stop_monitor = StopMonitorProcessor.process(json: result)
    return redirect_to :root unless stop_monitor.error_description.nil?

    @results = StopMonitorPresenter.new(stop_monitor: stop_monitor)
    render :results
  end
end
