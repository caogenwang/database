defmodule ConvertWeb.PageController do
    use ConvertWeb, :controller

    require Logger
    require Phoenix.Naming

    def get_page(conn, %{"id" => id, "page" => page} = params) do
        base_path = get_dir(id)
        path = base_path
        |> Path.join "page"
        |> Path.join page

        send_file(conn, path)
    end

    def get_font(conn, %{"id" => id, "font" => font} = params) do
        base_path = get_dir(id)
        path = base_path
        |> Path.join "font"
        |> Path.join font

        send_file(conn, path)
    end

    def get_file(conn, %{"id" => id} = params) do

        base_path = get_dir(id)
        path = base_path
        |> Path.join id <> ".pdf"

        send_file(conn, path)
    end

    def get_image(conn, %{"id" => id, "image" => image} = params) do
        base_path = get_dir(id)
        path = base_path
        |> Path.join "image"
        |> Path.join image

        send_file(conn, path)
    end

end
