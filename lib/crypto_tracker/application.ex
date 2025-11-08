defmodule CryptoTracker.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      CryptoTrackerWeb.Telemetry,
      CryptoTracker.Repo,
      {DNSCluster, query: Application.get_env(:crypto_tracker, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: CryptoTracker.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: CryptoTrackerFinch},
      # Start a worker by calling: CryptoTracker.Worker.start_link(arg)
      # {CryptoTracker.Worker, arg},
      # Start to serve requests, typically the last entry
      CryptoTrackerWeb.Endpoint,
      {CryptoTracker.PriceTracker, [:btc, :eth]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CryptoTracker.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CryptoTrackerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
