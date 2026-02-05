class TgbotMessages
  def initialize(bot, message, users_state_hash)
    @bot = bot
    @message = message
    @users_state_hash = users_state_hash
    @chat_id = message.chat.id
  end

  def user_state
    @users_state_hash[@chat_id]
  end

  def send_start(name)
    send_message(format(TEXTS['commands']['start'], name: name))
    @users_state_hash[@chat_id] = { step: "waiting_from_currency", from_currency: nil, from_currency_value: nil, to_currency: nil }
  end

  def send_stop(name)
    send_message(format(TEXTS['commands']['stop'], name: name))
  end

  def send_waiting_from_currency
    user_state[:from_currency] = @message.text
    from_currency = user_state[:from_currency]
    send_message(format(TEXTS['steps']['waiting_from_currency'], from_currency: from_currency))
    user_state[:step] = "waiting_from_currency_value"
  end

  def send_waiting_from_currency_value
    user_state[:from_currency_value] = @message.text.to_f
    from_currency = user_state[:from_currency]
    from_currency_value = user_state[:from_currency_value]
    send_message(format(TEXTS['steps']['waiting_from_currency_value'], from_currency: from_currency, from_currency_value: from_currency_value))
    user_state[:step] = "waiting_to_currency"
  end

  def send_waiting_to_currency
    user_state[:to_currency] = @message.text
    to_currency = user_state[:to_currency]
    send_message(format(TEXTS['steps']['waiting_to_currency'], to_currency: to_currency))
    user_state[:step] = "exchange_processing"
  end

  def send_exchange_processing(rate, output_currency_value)
    to_currency = user_state[:to_currency]
    from_currency = user_state[:from_currency]
    from_currency_value = user_state[:from_currency_value]

    send_message(format(TEXTS['steps']['exchange_processing'],
      to_currency: to_currency,
      from_currency: from_currency,
      rate: rate,
      from_currency_value: from_currency_value,
      output_currency_value: output_currency_value
    ))
    user_state[:step] = "exchange_done"
  end

  def send_exchange_done
    send_message(format(TEXTS['steps']['exchange_done']))
    @users_state_hash[@chat_id] = { step: "waiting_from_currency", from_currency: nil, from_currency_value: nil, to_currency: nil }
  end

  private

  def send_message(text)
    @bot.api.send_message(chat_id: @chat_id, text: text)
  end
end
