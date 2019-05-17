defmodule StoreSystem.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  import Amnesia
  
  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: StoreSystem.Worker.start_link(arg)
      # Supervisor.Spec.supervisor(StoreSystem.Worker, [])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [max_seconds: 1,
            max_restarts: 1_000_000,
            strategy: :one_for_one, 
            name: StoreSystem.Supervisor]

    Supervisor.start_link(children, opts)
  end
end
