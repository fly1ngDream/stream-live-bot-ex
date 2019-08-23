use Mix.Config

import_config "config.secret.exs"

config :stream_live_bot,
  client_id: System.get_env("TWITCH_CLIENT_ID"),
  ecto_repos: [StreamLiveBot.Repo],
  streamer_username: System.get_env("STREAMER_USERNAME")

config :stream_live_bot, StreamLiveBot.Repo,
  database: "stream_live_bot_repo",
  username: System.get_env("DB_USER"),
  password: System.get_env("DB_PASS"),
  hostname: "localhost"

config :tg_bot,
  commands: StreamLiveBot.TelegramBot

config :nadia,
  token: System.get_env("TELEGRAM_BOT_TOKEN")


import_config "#{Mix.env}.exs"
