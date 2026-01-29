require 'dotenv'
require_relative '../classes/ExchangerateRequest'

module Tgbot
    def get_currency_rate(from_currency, to_currency)
        data = ExchangerateRequest.new(to_currency).send_request
        rate = data['conversion_rates'][from_currency]
    end

    def convert_currency_rates(from_currency_value, currency_rate)
      output_currency_value = from_currency_value/currency_rate
    end
end

