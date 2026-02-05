class Listener
  def initialize(bot, users_state_hash)
    @bot = bot
    @users_state_hash = users_state_hash
  end

  def handle_message(message)
    chat_id = message.chat.id
    user_state = @users_state_hash[chat_id]
    main_bot = MainBot.new(@bot, message, @users_state_hash)

    if user_state
      handle_step(user_state, main_bot)
    else
      handle_command(message, main_bot)
    end
  end

  def handle_step(user_state, main_bot)
    step = user_state[:step]
    main_bot.send("send_#{step}")
  end

  def handle_command(message, main_bot)
    command = message.text.delete_prefix('/')
    main_bot.send("send_#{command}", message.from.first_name)
  end
end
