defmodule PubSubTest.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      PubSubTest.Repo,
      PubSubTest.Listener,
      # Start the Telemetry supervisor
      PubSubTestWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: PubSubTest.PubSub},
      # Start the Endpoint (http/https)
      PubSubTestWeb.Endpoint
      # Start a worker by calling: PubSubTest.Worker.start_link(arg)
      # {PubSubTest.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PubSubTest.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PubSubTestWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
