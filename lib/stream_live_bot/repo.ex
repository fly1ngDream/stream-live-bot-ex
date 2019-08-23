defmodule StreamLiveBot.Repo do
  use Ecto.Repo,
    otp_app: :stream_live_bot,
    adapter: Ecto.Adapters.Postgres
  import Ecto.Repo
  import Ecto.Query
  alias StreamLiveBot.Subscriber

  def add_subscriber(chat_id) do
    %Subscriber{}
    |> Subscriber.changeset(%{chat_id: chat_id})
    |> insert()
  end

  def remove_subscriber(chat_id), do: Subscriber |> get_by(chat_id: chat_id) |> delete()

  def get_subscribers_count() do
    query = from(s in Subscriber, select: s.chat_id)
    query |> all() |> length()
  end

  def get_subscribers() do
    query = from(s in Subscriber, select: s.chat_id)
    all(query)
  end
end
