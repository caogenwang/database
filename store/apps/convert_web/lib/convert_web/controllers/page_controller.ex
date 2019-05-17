defmodule ConvertWeb.PageController do
  use ConvertWeb, :controller

  require Logger
  require Phoenix.Naming

  def get_page(conn, %{"id" => id, "page" => page} = params) do
    conn = conn |> Plug.Conn.fetch_cookies()
    docin_session_id = Map.get(conn.req_cookies, "docin_session_id")

    case page |> String.split(".") |> List.first() do
      "page-" <> pn ->
        HKLogger.log(
          "page",
          "#{HKTime.local_time_str()},#{id},#{pn},#{docin_session_id}"
        )

      _ ->
        nil
    end

    base_path = get_dir(id)
    zip_file = base_path <> ".zip"

    file_path =
      base_path
      |> Path.basename()
      |> Path.join(
        "page"
        |> Path.join(page)
      )

    conn = send_file2(conn, zip_file, file_path)

    # unless File.exists?(zip_file) do
    #   dfs_master = DengtaFaxianzhe.find_by_type("dfs_master") |> List.first()

    #   qiandaoURL =
    #     "#{dfs_master["url"]}/store/del_file_index?id=#{id}&host_name=#{
    #       System.get_env("SERVER_NAME")
    #     }"

    #   HTTPoison.get(qiandaoURL)
    # end

    conn
  end

  def get_font(conn, %{"id" => id, "font" => font} = params) do
    base_path = get_dir(id)
    zip_file = base_path <> ".zip"

    file_path =
      base_path
      |> Path.basename()
      |> Path.join(
        "font"
        |> Path.join(font)
      )

    send_file2(conn, zip_file, file_path)
  end

  def get_file(conn, %{"id" => id, "code" => "huangkedashuaige"} = params) do
    base_path = get_dir(id)
    zip_file = base_path <> ".zip"

    file_path =
      base_path
      |> Path.basename()
      |> Path.join(id <> ".pdf")

    send_file2(conn, zip_file, file_path)
  end

  def get_image(conn, %{"id" => id, "image" => image} = params) do
    base_path = get_dir(id)
    zip_file = base_path <> ".zip"

    file_path =
      base_path
      |> Path.basename()
      |> Path.join(
        "image"
        |> Path.join(image)
      )

    send_file2(conn, zip_file, file_path)
  end

  def get_zipfile(conn, %{"id" => id} = params) do
    base_path = get_dir(id)
    zip_file = "#{base_path}.zip"

    unless File.exists?(zip_file) do
      dfs_master = DengtaFaxianzhe.find_by_type("dfs_master") |> List.first()

      qiandaoURL = "#{dfs_master["url"]}/store/del_file_index?id=#{id}&host_name=#{System.get_env("SERVER_NAME")}"

      HTTPoison.get(qiandaoURL)
    end

    send_download(conn, {:file, zip_file})

  end
end
