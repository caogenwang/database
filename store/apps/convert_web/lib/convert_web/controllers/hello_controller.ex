defmodule ConvertWeb.HelloController do
    use ConvertWeb, :controller
    use Timex
  
    require Logger
    import Phoenix.Naming

    def hello(conn, msg) do
        conn |> json(ok(%{meta: %{
            version: to_string(Application.spec(:convert_web,:vsn))
        }}))
    end

end