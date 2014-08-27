RESQUEHEALTH_CONFIG = YAML::load_file(File.join(File.dirname(__FILE__), '..', 'resque_health.yml'))[::Rails.env]
