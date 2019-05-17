defmodule ConvertWeb.Router do
  use ConvertWeb, :router

  require Logger

  pipeline :api do
    plug(:accepts, ["json"])
  end

  get("/hello", ConvertWeb.HelloController, :hello)

  options("/hello", ConvertWeb.HelloController, :hello)

  scope "/api", ConvertWeb do
    pipe_through(:api)

    get("/:id/page/:page", PageController, :get_page)

    get("/:id/font/:font", PageController, :get_font)

    get("/:id/image/:image", PageController, :get_image)

    get("/:id/file", PageController, :get_file)
    get("/:id/zipfile", PageController, :get_zipfile)
  end

  get("/send_file", ConvertWeb.EDFSController, :receive_converted_zip_file)
  post("/send_file", ConvertWeb.EDFSController, :receive_converted_zip_file)
  get("/del_file/:id", ConvertWeb.EDFSController, :real_del_file)

  options("/logs", ConvertWeb.LogController, :logs)
  post("/logs", ConvertWeb.LogController, :logs)
  get("/logs", ConvertWeb.LogController, :logs)

end
