HEALTHCHECK_CONFIG = YAML::load_file(File.join(File.dirname(__FILE__), '..', 'health_check.yml'))[::Rails.env]
