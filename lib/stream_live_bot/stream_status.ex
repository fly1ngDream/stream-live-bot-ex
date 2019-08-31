defmodule StreamLiveBot.StreamStatus do
  use Plug.Router
  use Plug.ErrorHandler

  @repo StreamLiveBot.Repo

  plug Plug.Parsers, parsers: [:json, :urlencoded], json_decoder: Poison
  plug :match
  plug :dispatch

  defp twitch_user_link(username), do: "twitch.tv/#{username}"

  defp send_notifications(subscribers, text) do
    Enum.map(
      subscribers,
      &Task.start(fn -> Nadia.send_message(&1, text) end)
    )
  end

  get "/stream_changed" do
    query_params = Plug.Conn.fetch_query_params(conn).query_params

    send_resp(conn, 200, Map.get(query_params, "hub.challenge"))
  end

  post "/stream_changed" do
    stream_online = System.get_env("STREAM_ONLINE")
    streams_data = Map.get(conn.params, "data")

    cond do
      streams_data != [] and stream_online == "false" ->
        System.put_env(
            "STREAM_ONLINE",
            "true"
        )
        twitch_streamer_link = twitch_user_link(
            Application.get_env(:stream_live_bot, :streamer_username)
        )
        send_notifications(
          @repo.get_subscribers(),
          "Stream started!\n#{twitch_streamer_link}"
        )

      streams_data == [] ->
        System.put_env(
            "STREAM_ONLINE",
            "false"
        )

      true -> nil
    end

    send_resp(conn, 200, "")
  end

  match _ do
    send_resp(conn, 404, "Oops!")
  end

  defp handle_errors(conn, %{kind: kind, reason: reason, stack: stack}) do
    IO.inspect(kind, label: :kind)
    IO.inspect(reason, label: :reason)
    IO.inspect(stack, label: :stack)

    send_resp(conn, conn.status, "Something went wrong")
  end
end
