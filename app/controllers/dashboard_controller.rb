require 'get_health'
require 'get_resque_health'
require 'airbrake_poller'

class DashboardController < ApplicationController
  before_filter :http_basic_authenticate

  def index
    render :locals => { :timestamp => Time.now.in_time_zone("America/Los_Angeles") }
  end

  def airbrake
    @timestamp = Time.now.in_time_zone("America/Los_Angeles")
    airbrake_poller = AirbrakePoller.new

    begin
      @recent_errors = airbrake_poller.get_five_most_recent_errors
    rescue => e
      notify_airbrake e
      @recent_errors = []
    end

    begin
      @frequent_errors = airbrake_poller.get_five_most_frequent_errors
    rescue => e
      notify_airbrake e
      @frequent_errors = []
    end
    render :partial => 'dashboard/airbrake', :locals => { :timestamp => @timestamp }
  end

  def health_check
    @status = GetHealth.get_health_data(params.fetch('datacenter'))
    render :partial => 'dashboard/health_check', :locals => { :timestamp => Time.now.in_time_zone("America/Los_Angeles"), :datacenter => params.fetch('datacenter') }
  end

  def resque
    @status = GetHealth.get_health_data(params.fetch('datacenter'))
    @resque_status = GetResqueHealth.get_resque_health_data(params.fetch('datacenter'))
    render :partial => 'dashboard/resque', :locals => { :timestamp => Time.now.in_time_zone("America/Los_Angeles"), :datacenter => params.fetch('datacenter') }
  end
end
