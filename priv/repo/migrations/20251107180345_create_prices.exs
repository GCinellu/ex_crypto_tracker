defmodule CryptoTracker.Repo.Migrations.CreatePrices do
  use Ecto.Migration

  def change do
    create table(:prices) do
      add :coin, :string
      add :price, :float

      timestamps(type: :utc_datetime)
    end
  end
end
