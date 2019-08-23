use Mix.Config

config :stream_live_bot,
  ecto_repos: [StreamLiveBot.Repo]

config :stream_live_bot, StreamLiveBot.Repo,
  database: "stream_live_bot_repo",
  hostname: "localhost"

config :tg_bot,
  commands: StreamLiveBot.TelegramBot


import_config "config.secret.exs"
import_config "#{Mix.env}.exs"
