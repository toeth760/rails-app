require 'spec_helper'

describe HealthCheckController do
  describe "#health" do
    it "returns 200 OK" do
      expect(get(:health).status).to eq 200
    end

    it "returns an empty ['dependencies']" do
      response = get(:health).body
      response = JSON.parse(response)
      expect(response['dependencies']).to eq({})
    end
  end
end
