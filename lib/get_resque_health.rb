require 'open-uri'

class GetResqueHealth
  def self.get_resque_health_data(datacenter)
    api_key = "?api_key=#{RESQUEHEALTH_CONFIG['api_key']}"
    url = URI.parse(RESQUEHEALTH_CONFIG[datacenter]['url'] + api_key)
    result = open(url).read
    resque_health_check = JSON.parse(result)
    return resque_health_check
  end
end
