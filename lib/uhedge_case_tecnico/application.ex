defmodule UhedgeCaseTecnico.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      UhedgeCaseTecnicoWeb.Telemetry,
      {DNSCluster,
       query: Application.get_env(:uhedge_case_tecnico, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: UhedgeCaseTecnico.PubSub},
      # Start a worker by calling: UhedgeCaseTecnico.Worker.start_link(arg)
      # {UhedgeCaseTecnico.Worker, arg},
      # Start to serve requests, typically the last entry
      UhedgeCaseTecnicoWeb.Endpoint,
      {AshAuthentication.Supervisor, [otp_app: :uhedge_case_tecnico]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: UhedgeCaseTecnico.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    UhedgeCaseTecnicoWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp skip_migrations?() do
    # By default, sqlite migrations are run when using a release
    System.get_env("RELEASE_NAME") == nil
  end
end
