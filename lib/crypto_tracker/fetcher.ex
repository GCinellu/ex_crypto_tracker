defmodule CryptoTracker.Fetcher do
  @moduledoc """
  Fetches live prices from CoinMarketCap API.
  """

  @base_url "https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest"

  def get_price(coin) when is_atom(coin), do: get_price(Atom.to_string(coin))

  def get_price(symbol) do
    api_key = Application.fetch_env!(:crypto_tracker, :coinmarketcap)[:api_key]

    if is_nil(api_key) do
      raise """
      CoinMarketCap API key is not set!

      Please set the COINMARKETCAP_API_KEY environment variable or add it to:
      - envs/.dev.env (for development)
      - envs/.env (for all environments)

      Get your API key from: https://coinmarketcap.com/api/
      """
    end

    headers = [
      {"X-CMC_PRO_API_KEY", api_key},
      {"Accept", "application/json"}
    ]

    url = "#{@base_url}?symbol=#{String.upcase(symbol)}"

    case Finch.build(:get, url, headers) |> Finch.request(CryptoTrackerFinch) do
      {:ok, %Finch.Response{status: 200, body: body}} ->
        with {:ok, decoded} <- Jason.decode(body),
             %{"data" => data_map} <- decoded,
             coin_data when is_map(coin_data) <- Map.get(data_map, String.upcase(symbol)),
             %{"quote" => %{"USD" => %{"price" => price}}} <- coin_data do
          Float.round(price, 2)
        else
          _ -> nil
        end

      {:ok, %Finch.Response{status: status}} ->
        IO.puts("Coinmarketcap returned status #{status}")
        nil

      {:error, reason} ->
        IO.inspect(reason, label: "HTTP error")
        nil
    end
  end
end
