class MainBot
  attr_reader :messages

  def initialize(bot, message, users_state_hash)
    @bot = bot
    @message = message
    @users_state_hash = users_state_hash
    @messages = TgbotMessages.new(bot, message, users_state_hash)
  end

  def send_start(name)
    @messages.send_start(name)
  end

  def send_stop(name)
    @messages.send_stop(name)
  end

  def send_waiting_from_currency
    @messages.send_waiting_from_currency
  end

  def send_waiting_from_currency_value
    @messages.send_waiting_from_currency_value
  end

  def send_waiting_to_currency
    @messages.send_waiting_to_currency
    process_exchange
  end

  def process_exchange
    user_state = @messages.user_state
    from_currency = user_state[:from_currency]
    to_currency = user_state[:to_currency]
    from_currency_value = user_state[:from_currency_value]

    currency_rate = get_currency_rate(from_currency, to_currency)
    to_currency_value = convert_currency_rates(from_currency_value, currency_rate)

    @messages.send_exchange_processing(currency_rate, to_currency_value)
    @messages.send_exchange_done
  end

  def get_currency_rate(from_currency, to_currency)
    data = ExchangerateRequest.new(to_currency).send_request
    data['conversion_rates'][from_currency]
  end

  def convert_currency_rates(from_currency_value, currency_rate)
    from_currency_value / currency_rate
  end
end
