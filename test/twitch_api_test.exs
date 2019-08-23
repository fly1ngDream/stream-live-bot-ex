defmodule TwitchAPITest do
  use ExUnit.Case
  doctest TwitchAPI

  test "get user id by username" do
    username = "twitch"
    user_id = 12826

    assert TwitchAPI.get_user_id_by_username(username) == user_id
  end

  test "is stream online" do
    username = "twitch"

    assert TwitchAPI.is_stream_online?(username) in [true, false]
  end
end
