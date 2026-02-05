require 'telegram/bot'
require 'net/http'
require 'json'
require 'dotenv'
require 'yaml'
require_relative 'classes/ExchangerateRequest'
require_relative 'classes/TgbotMessages'
require_relative 'classes/MainBot'
require_relative 'classes/Listener'

Dotenv.load('config/.env')
TEXTS = YAML.load_file('config/bot_texts.yml')['texts']
TOKEN = ENV['TOKEN_TG']
TOKEN_EXCHANGERATE = ENV['TOKEN_EXCHANGERATE']

users_state_hash = {}

Telegram::Bot::Client.run(TOKEN) do |bot|
  listener = Listener.new(bot, users_state_hash)

  bot.listen do |message|
    listener.handle_message(message)
  end
end
