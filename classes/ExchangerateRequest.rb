require 'dotenv'

class ExchangerateRequest
  URL = 'https://v6.exchangerate-api.com/v6/'
  attr_reader :url

  def initialize(path)
    @url = "#{URL}#{ENV['TOKEN_EXCHANGERATE']}/latest/#{path}"
  end

  def send_request
    uri = URI.parse(url)
    response = Net::HTTP.get(uri)
    JSON.parse(response)
  end

end