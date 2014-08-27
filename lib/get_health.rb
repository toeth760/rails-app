require 'open-uri'

class GetHealth
  def self.get_health_data(datacenter)
    api_key = "?api_key=#{RESQUEHEALTH_CONFIG['api_key']}"
    url = URI.parse(HEALTHCHECK_CONFIG[datacenter]['url'] + api_key)
    result = open(url).read
    health_check = JSON.parse(result)
    return health_check
  end
end
