INTERNAL_REPORTS = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'internal_reports.yml'))[::Rails.env]