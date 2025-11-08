defmodule CryptoTracker.CoinTrackerSupervisor do
  use DynamicSupervisor

  def start_link(_opts) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_coin(coin) do
    child_spec = {CryptoTracker.PriceTracker, coin: coin}
    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end
end
