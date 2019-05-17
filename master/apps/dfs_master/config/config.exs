use Mix.Config

config :dfs_master, ecto_repos: [DfsMaster.Repo]

import_config "#{Mix.env}.exs"
