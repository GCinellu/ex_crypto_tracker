defmodule CryptoTracker.Fetcher do
  def get_price(:btc), do: random_price(65000, 68000)
  def get_price(:eth), do: random_price(3200, 3600)

  defp random_price(min, max) do
    :rand.uniform() * (max - min) + min |> Float.round(2)
  end
end

