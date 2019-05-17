defmodule ConvertWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use ConvertWeb, :controller
      use ConvertWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: ConvertWeb
      import Plug.Conn
      import ConvertWeb.Router.Helpers
      import ConvertWeb.Gettext
      require Logger

      @doc "Simple API message helper, returns JSON with OK status"
      def ok(msg), do: %{status: :ok, content: msg}

      @doc "Simple API message helper, returns JSON with ERROR status"
      def error(code, reason), do: %{status: :error, content: %{code: code, reason: reason}}

      def send_file(conn, path, options \\ []) do
        conn = Plug.Conn.put_resp_header(conn, "cache-control", "max-age=0, public")
        # date = Timex.now |> Timex.format!("{RFC1123z}")

        case File.stat(path) do
            {:ok, stat} ->
                last_modified = ConvertWeb.DateTimeUtil.date_to_timestamp(stat.mtime) |> to_string
                req_modified = Plug.Conn.get_req_header(conn, "if-modified-since") |> List.first |> to_string
                if (String.equivalent?(last_modified, req_modified)) do
                    send_resp(conn, 304, "file not modified!")
                else
                    conn = Plug.Conn.put_resp_header(conn, "last-modified", last_modified)
                    send_download(conn, {:file, path}, [])
                end
            {:error, _} ->
                send_resp(conn, 404, "file not found!")
        end
      end

      defp formatted_diff(diff) when diff > 1000, do: [diff |> div(1000) |> Integer.to_string, "ms"]
      defp formatted_diff(diff), do: [Integer.to_string(diff), "µs"]

      defp get_dir(id) do
        base_dir = "/Documents"

        base_name = id
        |> String.to_charlist
        |> Enum.chunk_every(3)
        |> Enum.join("/")
        |> Path.join(id)

        Path.join(base_dir, base_name)
      end

    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/convert_web/templates",
        namespace: ConvertWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 2, view_module: 1]

      import ConvertWeb.Router.Helpers
      import ConvertWeb.ErrorHelpers
      import ConvertWeb.Gettext
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import ConvertWeb.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
