use Mix.Config

config :dfs_master, DfsMaster.Repo,
  adapter: Ecto.Adapters.MySQL,
  database: "dfs_master",
  username: "root",
  password: "123456",
  hostname: "192.168.4.39",
  port: "4436",
  pool_size: 10

# import_config "prod.secret.exs"
