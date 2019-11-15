defmodule StreamLiveBot.Application do
  use Application
  require Logger

  def start(_type, _args) do
    children = [
      {
        Plug.Cowboy,
        scheme: :http, plug: StreamLiveBot.StreamStatus, options: [port: cowboy_port()]
      },
      StreamLiveBot.Repo,
      %{
        id: "frequent",
        start: {
          SchedEx,
          :run_every,
          [
            TwitchAPI,
            :subscribe_for_stream_changes,
            [Application.get_env(:stream_live_bot, :streamer_username)],
            "* * */6 * *"
          ]
        }
      }
    ]

    opts = [strategy: :one_for_one, name: StreamLiveBot.Supervisor]

    Logger.info("Starting stream status application...")

    System.put_env(
      "STREAM_ONLINE",
      :stream_live_bot
      |> Application.get_env(:streamer_username)
      |> TwitchAPI.is_stream_online?()
      |> to_string()
    )

    _response =
      TwitchAPI.subscribe_for_stream_changes(
        Application.get_env(:stream_live_bot, :streamer_username)
      )

    Supervisor.start_link(children, opts)
  end

  defp cowboy_port, do: Application.get_env(:stream_live_bot, :cowboy_port, 8000)
end
