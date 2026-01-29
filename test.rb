require 'net/http'
require 'json'

# Setting URL
url = "https://v6.exchangerate-api.com/v6/fd9bc15bf03e46fa12a251e0/latest/USD"
uri = URI(url)
response = Net::HTTP.get(uri)
response_obj = JSON.parse(response)

# Getting a rate
rate = response_obj['conversion_rates']['EUR']

puts rate