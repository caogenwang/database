use Mix.Config

# Configure your database
config :dfs_master, DfsMaster.Repo,
  adapter: Ecto.Adapters.MySQL,
  database: "dfs_masters",
  username: "root",
  password: "123456",
  hostname: "0.0.0.0",
  port: "14444",
  pool: Ecto.Adapters.SQL.Sandbox

config :dfs_master, DfsMaster.OldRepo,
  adapter: Ecto.Adapters.MySQL,
  database: "dfs_masters",
  username: "root",
  password: "123456",
  hostname: "192.168.2.56",
  port: "4444",
  pool_size: 10,
  pool: Ecto.Adapters.SQL.Sandbox
