defmodule HKPlug.Logger do
    @moduledoc """
    A plug for logging basic request information in the format:

        GET /index.html
        Sent 200 in 572ms

    To use it, just plug it into the desired module.

        plug Plug.Logger, log: :debug

    ## Options

      * `:log` - The log level at which this plug should log its request info.
        Default is `:info`.
    """

    require Logger
    alias Plug.Conn
    @behaviour Plug

    def init(opts) do
      Keyword.get(opts, :log, :info)
    end

    def call(conn, level) do
      Logger.info "#{inspect conn.request_path} #{inspect conn.params} in"

      start = System.monotonic_time()

      Plug.Conn.register_before_send(conn, fn conn ->
        stop = System.monotonic_time()
        diff = System.convert_time_unit(stop - start, :native, :micro_seconds)

        Logger.info "#{inspect conn.request_path} #{inspect conn.params} out"

        if diff > 1 * 1000 * 1000 do
          Logger.warn "#{inspect conn.request_path} #{inspect conn.params} #{formatted_diff(diff)}"
        else
          Logger.info "#{inspect conn.request_path} #{inspect conn.params} #{formatted_diff(diff)}"
        end

        Plug.Conn.put_resp_header(conn, "service", System.get_env("SERVER_NAME"))
      end)
    end

    defp formatted_diff(diff) when diff > 1000, do: [diff |> div(1000) |> Integer.to_string(), "ms"]
    defp formatted_diff(diff), do: [Integer.to_string(diff), "µs"]

    defp connection_type(%{state: :set_chunked}), do: "Chunked"
    defp connection_type(_), do: "Sent"
  end
