defmodule Convert.Umbrella.Mixfile do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options.
  #
  # Dependencies listed here are available only for this project
  # and cannot be accessed from applications inside the apps folder
  def third_apps do
    if Mix.env == :prod do
      "/Applications/third_apps"
    else
      Path.join(["..","..","third_apps"])
    end
  end

  defp deps do
    [
      {:hkgo, path: "#{third_apps()}/hkgo"},
      {:amnesia, path: "#{third_apps()}/amnesia"},
      {:arc, path: "#{third_apps()}/arc"},
      {:entice, path: "#{third_apps()}/entice"},
      {:logger_file_backend, path: "#{third_apps()}/logger_file_backend"},
      {:dengta_faxianzhe, path: "#{third_apps()}/dengta_faxianzhe"},
      {:distillery, "~> 2.0", runtime: false},
    ] 
  end
end
