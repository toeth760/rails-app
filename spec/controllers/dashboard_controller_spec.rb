require 'spec_helper'
require 'airbrake-api'
require 'airbrake_poller'

describe DashboardController do
  let(:api_key) {RESQUEHEALTH_CONFIG['api_key']}

  before do
    http_basic_login
  end

  describe "#index" do
    it "renders the index view" do
      get :index
      expect(response).to render_template('index')
    end

  end

  describe "#airbrake" do
    before :each do
      stub_request(:get, "https://realpractice.airbrake.io/projects/85939/groups.xml?auth_token=f456e6708f0cada0a1a12c3047c0da9434406929&page=1").
        to_return(:status => 200, :body => "<?xml version=\"1.0\" encoding=\"UTF-8\"?><nil-classes type=\"array\"/>", :headers => {})
    end

    it "calls the airbrake poller" do
      expect(AirbrakePoller).to receive(:new)
      get :airbrake
    end

    it "gets the 5 most frequent errors" do
      expect_any_instance_of(AirbrakePoller).to receive(:get_five_most_recent_errors)
      get :airbrake
    end

    it "gets the 5 latest errors" do
      expect_any_instance_of(AirbrakePoller).to receive(:get_five_most_frequent_errors)
      get :airbrake
    end

    it "renders the airbrake partial view" do
      get :airbrake
      expect(response).to render_template('_airbrake')
    end
  end

  describe "#health_check" do
    before :each do
      stub_request(:get, "http://66.150.153.19/capture_api/health.json?api_key=#{api_key}").
        to_return(:status => 200, :body => '{"dependencies":{"cassandra_connection":"OK","redis_connection":"OK","resque_workers":"WARN","stuck_jobs":"OK"},"version":"0.37.2"}', :headers => {})
    end

    it "gets the health JSON" do
      expect(GetHealth).to receive(:get_health_data).with('lax')
      get :health_check, {:datacenter => 'lax'}
    end

    it "renders the health partial view" do
      get :health_check, {:datacenter => 'lax'}
      expect(response).to render_template('_health_check')
    end
  end

  describe "#resque" do
    before :each do
      stub_request(:get, "http://65.97.51.19/capture_api/resque_health.json?api_key=#{api_key}").
        to_return(:status => 200, :body => '{"pending":0,"processed":0,"queues":0,"workers":0,"working":0,"failed":0,"servers":["redis://capture.services.dev:6379/0"],"environment":"development","queue_names":{}}', :headers => {})
      stub_request(:get, "http://65.97.51.19/capture_api/health.json?api_key=#{api_key}").
        to_return(:status => 200, :body => '{"dependencies":{"cassandra_connection":"OK","redis_connection":"OK","resque_workers":"WARN","stuck_jobs":"OK"},"version":"0.37.2"}', :headers => {})
    end

    it "gets the resque health JSON" do
      expect(GetResqueHealth).to receive(:get_resque_health_data).with('iad')
      get :resque, {:datacenter => 'iad'}
    end

    it "gets the health JSON" do
      expect(GetHealth).to receive(:get_health_data).with('iad')
      get :resque, {:datacenter => 'iad'}
    end

    it "renders the health partial view" do
      get :resque, {:datacenter => 'iad'}
      expect(response).to render_template('_resque')
    end
  end

end
