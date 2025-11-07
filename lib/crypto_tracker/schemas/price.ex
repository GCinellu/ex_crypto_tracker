defmodule CryptoTracker.Price do
  use Ecto.Schema

  schema "prices" do
    field :coin, :string
    field :price, :float

    timestamps(type: :utc_datetime)
  end
end
