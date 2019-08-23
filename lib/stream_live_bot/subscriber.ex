defmodule StreamLiveBot.Subscriber do
  use Ecto.Schema
  import Ecto.Changeset


  schema "subscribers" do
    field :chat_id, :integer
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:chat_id])
    |> validate_required([:chat_id])
    |> unique_constraint(:chat_id)
  end
end
