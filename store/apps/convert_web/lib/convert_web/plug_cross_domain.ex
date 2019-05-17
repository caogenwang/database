defmodule Plug.CrossDomain do
    import Plug.Conn
    require Logger

    def init(options) do
        options
    end
    
    def call(conn, _opts) do        
        conn
        |> Plug.Conn.put_resp_header("Access-Control-Allow-Origin", "*")
        |> Plug.Conn.put_resp_header("Access-Control-Max-Age", "3600")
        |> Plug.Conn.put_resp_header("Access-Control-Allow-Headers", "Origin,Accept,X-Requested-With,Content-Type,Access-Control-Request-Method,Access-Control-Request-Headers,Authorization")
        |> Plug.Conn.put_resp_header("Access-Control-Allow-Methods", "POST,GET,OPTIONS,DELETE,PUT")
    end

end