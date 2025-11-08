defmodule CryptoTracker.PriceTracker do
  use GenServer
  alias CryptoTracker.{Repo, Price}

  @update_interval :timer.seconds(10)

  def start_link(opts) do
    coin = Keyword.fetch!(opts, :coin)
    GenServer.start_link(__MODULE__, coin, name: via_tuple(coin))
  end

  def get_price(pid), do: GenServer.call(pid, :get_price)

  def init(coin) do
    state = %{coin: coin, price: nil, updated_at: nil}
    schedule_update()
    {:ok, state}
  end

  def handle_info(:update_price, state) do
    coin = state.coin
    price = CryptoTracker.Fetcher.get_price(coin)
    now = DateTime.utc_now() |> DateTime.truncate(:second)
    IO.inspect(price, label: "Fetched price for #{coin}")

    %Price{coin: Atom.to_string(coin), price: price, updated_at: now}
    |> Repo.insert!()

    new_state = %{state | price: price, updated_at: now}
    schedule_update()
    {:noreply, new_state}
  end

  def handle_call(:get_price, _from, state), do: {:reply, state, state}

  defp schedule_update() do
    Process.send_after(self(), :update_price, @update_interval)
  end

  defp via_tuple(coin), do: {:via, Registry, {CryptoTracker.Registry, coin}}
end

