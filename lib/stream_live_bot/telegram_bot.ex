defmodule StreamLiveBot.TelegramBot do
  use Telegram.Router
  use Telegram.Commander
  require Logger

  @repo StreamLiveBot.Repo

  command "start" do
    chat_id = get_chat_id()

    case @repo.add_subscriber(chat_id) do
      {:ok, _struct} ->
        Logger.info("* #{chat_id} subscribed.")
        send_message("You've subscribed for stream notifications.")

      {:error, _changeset} ->
        send_message("You are already subscribed!")
    end

    Logger.info("* Subscribers count: #{@repo.get_subscribers_count()}.")
  end

  command "stop" do
    chat_id = get_chat_id()

    case @repo.remove_subscriber(chat_id) do
      {:ok, _struct} ->
        Logger.info("* #{chat_id} unsubscribed.")
        send_message("You've unsubscribed")

      {:error, _changeset} ->
        send_message("You are not subscribed!")
    end

    Logger.info("* Subscribers count: #{@repo.get_subscribers_count()}.")
  end
end
