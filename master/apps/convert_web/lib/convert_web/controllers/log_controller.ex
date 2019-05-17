defmodule MyProjectWeb.LogController do
  use ConvertWeb, :controller
  require Logger
  import Phoenix.Naming

  def logs(conn, msg) do
    conn |> json(ok(%{logs: logs}))
  end

  @logs "/System/logs"

  def logs do
    File.ls!(@logs)
    |> Enum.map(fn file ->
      {file, logFiles(file)}
    end)
    |> Enum.into(%{})
  end

  defp logFiles(type) do
    case File.ls(Path.join(@logs, type)) do
      {:ok, files} ->
        files |> Enum.sort(&(&1 >= &2))

      _ ->
        []
    end
  end
end
