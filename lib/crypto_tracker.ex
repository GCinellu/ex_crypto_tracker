defmodule CryptoTracker do
  alias CryptoTracker.PriceTracker
  def start_tracker(coins \\ [:btc, :etc]) do
    PriceTracker.start_link(coins)
  end

  def get_price(coin), do: PriceTracker.get_price(coin)
end
