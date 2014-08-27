require 'spec_helper'
require 'get_health'

describe GetHealth do
  describe ".get_health_data" do
    let(:api_key) { "?api_key=#{RESQUEHEALTH_CONFIG['api_key']}" }

    it "parses the health check url from config data" do
      expect(URI).to receive(:parse).with(HEALTHCHECK_CONFIG['lax']['url'] + api_key).and_return(double.as_null_object)
      allow(JSON).to receive(:parse).and_return(double.as_null_object)
      GetHealth.get_health_data('lax')
    end

    it "opens the url" do
      allow(URI).to receive(:parse).with(HEALTHCHECK_CONFIG['lax']['url'] + api_key).and_return(double.as_null_object)
      expect(JSON).to receive(:parse).and_return(double.as_null_object)
      GetHealth.get_health_data('lax')
    end

    it "returns the JSON from the health check service" do
      json_data = double.as_null_object
      allow(URI).to receive(:parse).with(HEALTHCHECK_CONFIG['lax']['url'] + api_key).and_return(double.as_null_object)
      allow(JSON).to receive(:parse).and_return(json_data)
      expect(GetHealth.get_health_data('lax')).to eq(json_data)
    end
  end
end
