# CryptoTracker

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

# CryptoTracker Improvements Checklist

## ✅ Completed
- [x] Implemented a mocked price fetcher for development
- [x] Created `CryptoTracker.Fetcher` to fetch live prices from CoinMarketCap API
- [x] Added environment variable support for API key via `.env` files
- [x] Implemented a `PriceTracker` GenServer per coin
- [x] Introduced `CoinTrackerSupervisor` (DynamicSupervisor) to manage coin processes
- [x] Set up `Registry` to uniquely identify each coin GenServer
- [x] Price fetching and database insertion works correctly
- [x] Handled `:utc_datetime` microseconds issue with DB inserts

## ☐ To Improve
- [ ] Switch from `Process.send_after` to `:timer.send_interval` for fixed update intervals
- [ ] Add retry/backoff logic for API failures to prevent temporary outages from crashing the GenServer
- [ ] Decouple fetching from database writes for better fault tolerance
- [ ] Introduce telemetry events to track fetch success, latency, and errors
- [ ] Configure an in-memory cache (ETS or `:persistent_term`) for fast price reads
- [ ] Enable dynamic addition of new coins at runtime
- [ ] Implement global rate limiting to respect CoinMarketCap API quotas
- [ ] Create a mock/stub Fetcher for tests to avoid hitting the real API
- [ ] Add logging/alerts for repeated GenServer crashes or failed fetches

