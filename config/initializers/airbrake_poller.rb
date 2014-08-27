AIRBRAKE_POLLER_CONFIG = YAML::load_file(File.join(File.dirname(__FILE__), '..', 'airbrake_poller.yml'))[::Rails.env]
