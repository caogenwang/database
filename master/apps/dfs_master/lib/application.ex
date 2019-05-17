defmodule DfsMaster.Application do
  @moduledoc """
  The DfsMaster Application Service.

  The dfs_master system business domain lives in this application.

  Exposes API to clients such as the `DfsMasterWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # HKLogger.configure(%{path: "/System/logs"})

    opts = [max_seconds: 1,
            max_restarts: 1_000_000,
            strategy: :one_for_one,
            name: DfsMaster.Supervisor]

    w = Supervisor.start_link([
      supervisor(DfsMaster.Repo, []),
      # supervisor(DfsMaster.OldRepo, []),
      # supervisor(DATABASE.Process, []),
    ], opts)

    w
  end
end
