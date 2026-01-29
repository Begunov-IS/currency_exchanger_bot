require 'dotenv'
require 'yaml'
require_relative '../classes/ExchangerateRequest'
require_relative 'Tgbot'

module Tgbot_messages
    def send_start(bot, message, users_state_hash, name)
        bot.api.send_message(chat_id: message.chat.id, text: format(TEXTS['commands']['start'], name: "#{name}"))
        users_state_hash[message.chat.id] = {step: "waiting_from_currency", from_currency: nil, from_currency_value: nil, to_currency: nil}
    end

    def send_stop(bot, message, name)
        bot.api.send_message(chat_id: message.chat.id, text: format(TEXTS['commands']['stop'], name: "#{name}"))
    end

    def send_waiting_from_currency(bot, message, users_state_hash, from_currency)
        bot.api.send_message(chat_id: message.chat.id, text: format(TEXTS['steps']['waiting_from_currency'], from_currency: "#{from_currency}"))
        users_state_hash[message.chat.id][:from_currency] = message.text
        users_state_hash[message.chat.id][:step] = "waiting_from_currency_value"
    end

    def send_waiting_from_currency_value(bot, message, users_state_hash, from_currency, from_currency_value)
        bot.api.send_message(chat_id: message.chat.id, text: format(TEXTS['steps']['waiting_from_currency_value'], from_currency: "#{from_currency}", from_currency_value: "#{from_currency_value}"))
        users_state_hash[message.chat.id][:from_currency_value] = message.text.to_f
        users_state_hash[message.chat.id][:step] = "waiting_to_currency"
    end

    def send_waiting_to_currency(bot, message, users_state_hash, to_currency)
        bot.api.send_message(chat_id: message.chat.id, text: format(TEXTS['steps']['waiting_to_currency'], to_currency: "#{to_currency}"))
        users_state_hash[message.chat.id][:to_currency] = message.text
        users_state_hash[message.chat.id][:step] = "exchange_processing"
    end

    def send_exchange_processing(bot, message, users_state_hash, to_currency, from_currency, rate, from_currency_value, output_currency_value)
        bot.api.send_message(chat_id: message.chat.id, text: format(TEXTS['steps']['exchange_processing'], to_currency: "#{to_currency}", from_currency: "#{from_currency}",
        rate: "#{rate}", from_currency_value: "#{from_currency_value}", output_currency_value: "#{output_currency_value}"))
        users_state_hash[message.chat.id][:to_currency] = message.text
        users_state_hash[message.chat.id][:step] = "exchange_done"
    end

    def send_exchange_done(bot, message, users_state_hash)
        bot.api.send_message(chat_id: message.chat.id, text: format(TEXTS['steps']['exchange_done']))
        users_state_hash[message.chat.id] = {step: "waiting_from_currency", from_currency: nil, from_currency_value: nil, to_currency: nil}
    end

end