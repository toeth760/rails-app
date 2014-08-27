require 'airbrake-api'

class AirbrakePoller
  AIRBRAKE_PROJECT_ID = 85939

  def initialize
    connect
  end

  def get_five_most_recent_errors
    errors = AirbrakeAPI.errors(:project_id => AIRBRAKE_PROJECT_ID, :page => 1)
    errors = [] if errors.nil?
    return self.class.select_first_five(errors)
  end

  def get_five_most_frequent_errors
    return self.class.select_first_five(self.class.sort_errors_by_notices_count_in_descending_order(get_all_errors))
  end

  def self.select_first_five(errors)
    raise ArgumentError, 'Argument is not iterable' unless errors.respond_to?(:first)
    return errors.first(5)
  end

  def self.sort_errors_by_notices_count_in_descending_order(errors)
    return errors.sort { |a,b| b.notices_count <=> a.notices_count }
  end

  private

  def connect
    AirbrakeAPI.configure(
      :account => AIRBRAKE_POLLER_CONFIG['account'],
      :auth_token => AIRBRAKE_POLLER_CONFIG['auth_token'],
      :secure => AIRBRAKE_POLLER_CONFIG['secure']
    )
  end

  def get_all_errors
    all_errors = []
    page = 1
    errors = AirbrakeAPI.errors :project_id => AIRBRAKE_PROJECT_ID, :page => page

    while errors != [] do
      all_errors.concat(errors)
      page += 1
      errors = AirbrakeAPI.errors :project_id => AIRBRAKE_PROJECT_ID, :page => page
    end

    return all_errors
  end
end
