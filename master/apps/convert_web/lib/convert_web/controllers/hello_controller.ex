defmodule ConvertWeb.HelloController do
    use ConvertWeb, :controller
    use Timex
  
    require Logger
    import Phoenix.Naming

    # plug :put_headers, %{
    #     "Access-Control-Allow-Origin": "*",
    #     "Access-Control-Max-Age": "3600",
    #     "Access-Control-Allow-Headers": "Origin,Accept,X-Requested-With,Content-Type,Access-Control-Request-Method,Access-Control-Request-Headers,Authorization",
    #     "Access-Control-Allow-Methods": "POST,GET,OPTIONS,DELETE,PUT"}

    def hello(conn, msg) do
        conn |> json(ok(%{meta: %{
            version: to_string(Application.spec(:convert_web,:vsn))
        }}))
    end

    def node_test(conn, msg) do
        msg = Node.connect :"ke@192.168.2.56"
        
        Logger.debug "#{inspect msg}"
        Logger.debug "#{inspect Node.self}"
        Logger.debug "#{inspect Node.list}"
        Logger.debug "#{inspect Node.get_cookie}"
        conn |> json(ok(%{}))
    end

    def put_headers(conn, maps) do
        maps |> Enum.reduce(conn, fn {k, v}, conn ->
            Plug.Conn.put_resp_header(conn, to_string(k), v)
        end)
    end

end