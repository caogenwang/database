defmodule ConvertWeb.Mixfile do
  use Mix.Project

  @version String.trim(File.read!("../../_build/#{Mix.env}/version"))

  def project do
    [
      app: :convert_web,
      version: @version,
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext,:phoenix_swagger] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {ConvertWeb.Application, []},
      extra_applications: [:logger, :runtime_tools, :amnesia,:arc,:entice,:logger_file_backend,:store_manager,:dengta_faxianzhe,:hkgo]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix_swagger, "~> 0.8"},
      {:phoenix, "~> 1.3.0"},
      {:phoenix_pubsub, "~> 1.0"},
      {:gettext, "~> 0.11"},
      {:plug_cowboy, "~> 1.0", override: true},
      {:timex, "~> 3.4"},
      {:exactor, "~> 2.2.3", warn_missing: false}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    []
  end
end
