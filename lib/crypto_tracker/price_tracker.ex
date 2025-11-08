defmodule CryptoTracker.PriceTracker do
  use GenServer
  alias CryptoTracker.{Ecto, Repo}

  @update_interval :timer.seconds(60)

  def start_link(coins) do
    GenServer.start_link(__MODULE__, coins, name: __MODULE__)
  end

  def get_price(coin), do: GenServer.call(__MODULE__, {:get_price, coin})

  def init(coins) do
    state =
      Enum.map(coins, fn coin -> 
        {coin, %{price: nil, updated_at: nil}}
      end)
      |> Enum.into(%{})

    schedule_update()
    {:ok, state}
  end

  def handle_info(:update_prices, state) do
    new_state =
      Enum.into(state, %{}, fn {coin, _} -> 
        price = CryptoTracker.Fetcher.get_price(coin)

        %CryptoTracker.Price{coin: Atom.to_string(coin), price: price}
        |> Repo.insert!()

        {coin, %{price: price, updated_at: DateTime.utc_now()}}
      end)

    Process.send_after(self(), :update_prices, @update_interval)

    {:noreply, new_state}
  end

  def handle_call({:get_price, coin}, _from, state) do
    {:reply, Map.get(state, coin), state}
  end

  defp schedule_update() do
    Process.send_after(self(), :update_prices, @update_interval)
  end

  defp record_price(coin, price) do
    if Code.ensure_loaded?(Repo) do
      %CryptoTracker.Price{coin: coin, price: price, inserted_at: DateTime.utc_now()}
      |> Repo.insert()
    end
  end
end
