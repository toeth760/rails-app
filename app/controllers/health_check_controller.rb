class HealthCheckController < ApplicationController
  def health
    health = { 'dependencies' => {}, 'version' => CaptureDashboard::VERSION }
    render json: health.to_hash
  end
end
