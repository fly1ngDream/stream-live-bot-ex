defmodule StreamLiveBot.Repo.Migrations.CreateSubscribers do
  use Ecto.Migration

  def change do
    create table(:subscribers) do
      add :chat_id, :integer, unique: true
    end

    create unique_index(:subscribers, [:chat_id])
  end
end
