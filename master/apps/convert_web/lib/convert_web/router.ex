defmodule ConvertWeb.Router do
  use ConvertWeb, :router

  require Logger

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :store do
    plug(:accepts, ["json"])
  end

  get "/logs", MyProjectWeb.LogController, :logs

  get("/hello", ConvertWeb.HelloController, :hello)

  options("/hello", ConvertWeb.HelloController, :hello)

  get("/node_test", ConvertWeb.HelloController, :node_test);

  scope "/api", ConvertWeb do
    pipe_through(:api)

    get("/convert_status", EDFSController, :convert_status)

  end

  scope "/store", ConvertWeb do
    pipe_through(:store)

    get("/", EDFSController, :get_all_store)
    options("/", EDFSController, :get_all_store)
    post("/add_file_index", EDFSController, :add_file_index)
    get("/del_file_index", EDFSController, :del_file_index)
    get("/file_count", EDFSController, :get_file_count)
  end

  get("/get_upload_url", ConvertWeb.EDFSController, :get_upload_url)

end
