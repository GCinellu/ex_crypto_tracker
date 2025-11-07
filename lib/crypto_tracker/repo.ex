defmodule CryptoTracker.Repo do
  use Ecto.Repo,
    otp_app: :crypto_tracker,
    adapter: Ecto.Adapters.Postgres
end
