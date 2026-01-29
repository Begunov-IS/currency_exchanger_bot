require 'telegram/bot'
require 'net/http'
require 'json'
require 'dotenv'
require 'yaml'
require_relative 'modules/Tgbot'
require_relative 'modules/Tgbot_messages'
require_relative 'classes/Main_bot'
require_relative 'classes/ExchangerateRequest'

Dotenv.load
TEXTS = YAML.load_file('texts.yml')['texts']
TOKEN = ENV['TOKEN_TG']
TOKEN_EXCHANGERATE = ENV['TOKEN_EXCHANGERATE']

my_bot = Main_bot.new

users_state_hash = {}

Telegram::Bot::Client.run(TOKEN) do |bot|
  bot.listen do |message|
    if users_state_hash[message.chat.id]
      case users_state_hash[message.chat.id][:step]
      when "waiting_from_currency"
        my_bot.send_waiting_from_currency(bot, message, users_state_hash, users_state_hash[message.chat.id][:from_currency])

      when "waiting_from_currency_value"
        my_bot.send_waiting_from_currency_value(bot, message, users_state_hash, users_state_hash[message.chat.id][:from_currency], users_state_hash[message.chat.id][:from_currency_value])

      when "waiting_to_currency"
        my_bot.send_waiting_to_currency(bot, message, users_state_hash, users_state_hash[message.chat.id][:to_currency])
        currency_rate = my_bot.get_currency_rate(users_state_hash[message.chat.id][:from_currency], users_state_hash[message.chat.id][:to_currency])
        to_currency_value = my_bot.convert_currency_rates(users_state_hash[message.chat.id][:from_currency_value], currency_rate)
        my_bot.send_exchange_processing(bot, message, users_state_hash, users_state_hash[message.chat.id][:to_currency], users_state_hash[message.chat.id][:from_currency], currency_rate,
        users_state_hash[message.chat.id][:from_currency_value], to_currency_value)
        my_bot.send_exchange_done(bot, message, users_state_hash)
      end

    else
      case message.text
      when '/start'
        my_bot.send_start(bot, message, users_state_hash, message.from.first_name)

      when '/stop'
        my_bot.send_stop(bot, message, message.from.first_name)
      end
    end
  end
end