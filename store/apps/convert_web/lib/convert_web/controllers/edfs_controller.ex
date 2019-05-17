defmodule ConvertWeb.EDFSController do
    use ConvertWeb, :controller

    require Logger
    require Phoenix.Naming

    def receive_converted_zip_file(conn, %{"file" => file} = params) do
        filename = file.filename
        tmp_path = file.path

        id = Path.rootname(filename)
        base_path = get_dir(id)

        base_path = Path.dirname(base_path)
        File.mkdir_p(base_path)

        filename = Path.join(base_path, filename)
        tempFile = Path.join(base_path, UUID.uuid4())
        File.copy!(tmp_path, tempFile)
        File.rename(tempFile, filename)

        dfs_master = DengtaFaxianzhe.find_by_type("dfs_master") |> List.first
        addFileURL = "#{dfs_master["url"]}/store/add_file_index"
        meta_map = remake_meta_info(id)
        Logger.info "file: #{inspect Path.basename(__ENV__.file)}  line: #{__ENV__.line}
        #{inspect addFileURL}"
        Logger.info "file: #{inspect Path.basename(__ENV__.file)}  line: #{__ENV__.line}
        #{inspect meta_map}"
        case HTTPoison.post addFileURL, Poison.encode!(meta_map), [{"Content-Type", "application/json"}] do
            {:ok, %{status_code: 200}} ->
                conn |> json(ok(%{}))
            what ->
                Logger.error "file: #{inspect Path.basename(__ENV__.file)}  line: #{__ENV__.line}
                #{inspect what}"
                conn |> json(error(500, "add_file error???"))
        end

    end

    def receive_converted_zip_file(conn, params) do
        Logger.warn "file: #{inspect Path.basename(__ENV__.file)}  line: #{__ENV__.line}
        params: #{inspect params}"

        conn |> json(error(500, "add_file error???"))
    end

    def real_del_file(conn, %{"id" => id} = params) do
        Logger.info "file: #{inspect Path.basename(__ENV__.file)}  line: #{__ENV__.line}
        #{inspect params}"
        if params["immediately"] == "1" do
            File.rm(Store.get_dir(id)<>".zip")
        else
            File.Delete.deleteFile(id)
        end

        dfs_master = DengtaFaxianzhe.find_by_type("dfs_master") |> List.first()
        qiandaoURL = "#{dfs_master["url"]}/store/del_file_index?id=#{id}&host_name=#{System.get_env("SERVER_NAME")}"
        HTTPoison.get(qiandaoURL)

        conn |> json(ok(%{}))
    end

    def remake_meta_info(id) do
        base_path = get_dir(id)
        zip_path = base_path <> ".zip"

        meta_path = Path.basename(base_path) |> Path.join("meta.json")

        {:ok, file_stat} = File.stat(zip_path)

        {:ok, handler} = :zip.zip_open(String.to_charlist(zip_path), [:memory])
        {:ok, {_filename, resp}} = :zip.zip_get(String.to_charlist(meta_path), handler)
        :zip.zip_close(handler)

        {:ok, json} = Poison.Parser.parse resp
        json = json
        |> Map.put("id", id)
        |> Map.put("host_name", System.get_env("SERVER_NAME"))
        |> Map.put("zip_size", file_stat.size)
    end


end
