defmodule TwitchAPI do
  require Logger

  @url "https://api.twitch.tv/helix"
  @headers [{"Client-ID", Application.get_env(:stream_live_bot, :client_id)}]

  defmodule UsernameError do
    defexception message: "Invalid username"
  end

  @doc """
  Gets streamer's user id by username
  """
  def get_user_id_by_username(username) do
    users_url = "#{@url}/users?login=#{username}"

    response = users_url |> HTTPoison.get!(@headers)
    users_data = response.body |> Poison.decode!() |> Map.get("data")

    if users_data == [] do
      raise UsernameError
    else
      users_data |> Enum.at(0) |> Map.get("id") |> String.to_integer()
    end
  end

  @doc """
  Checks if stream is online
  """
  def is_stream_online?(username) do
    user_id = get_user_id_by_username(username)
    streams_url = "#{@url}/streams?user_id=#{user_id}"

    response = HTTPoison.get!(streams_url, @headers)
    streams_data = response.body |> Poison.decode!() |> Map.get("data")

    if streams_data != [], do: true, else: false
  end

  @doc """
  Subscribes for stream changes using webhook
  """
  def subscribe_for_stream_changes(username) do
    user_id = get_user_id_by_username(username)
    webhooks_hub_url = "#{@url}/webhooks/hub"

    ip = Application.get_env(:stream_live_bot, :ip)

    hub_data = %{
      "hub.callback" => "http://#{ip}:8000/stream_changes",
      "hub.mode" => "subscribe",
      "hub.topic" => "#{@url}/streams?user_id=#{user_id}",
      "hub.lease_seconds" => 864_000
    }

    Logger.log(:info, "Subscribing for stream updates...")

    HTTPoison.post!(
      webhooks_hub_url,
      Poison.encode!(hub_data),
      @headers
    )

    Logger.log(:info, "Subscribed.")
  end
end
