defmodule ConvertWeb.Application do
  use Application
  require Logger

  @config_file_name "config.json"

  def start(_type, _args) do
    import Supervisor.Spec

    HKLogger.configure(%{path: "/System/logs"})
    # Define workers and child supervisors to be supervised
    children = [
      # Start the endpoint when the application starts
      supervisor(ConvertWeb.Endpoint, []),
      supervisor(ConvertWeb.Constants, []),
      # Start your own worker by calling: ConvertWeb.Worker.start_link(arg1, arg2, arg3)
      # worker(ConvertWeb.Worker, [arg1, arg2, arg3]),
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [max_seconds: 1,
            max_restarts: 1_000_000,
            strategy: :one_for_one,
            name: ConvertWeb.Supervisor]

    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ConvertWeb.Endpoint.config_change(changed, removed)
    :ok
  end

end
