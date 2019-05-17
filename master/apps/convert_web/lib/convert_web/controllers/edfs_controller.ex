defmodule ConvertWeb.EDFSController do
    use ConvertWeb, :controller

    require Logger
    require Phoenix.Naming

    def add_file_index(conn, %{"id" => id} = meta) do
        w = DfsMaster.Repo.FileMeta.Service.insert(%{id: id, meta: Poison.encode!(meta)})
        Logger.info "file: #{inspect Path.basename(__ENV__.file)}  line: #{__ENV__.line}
        #{inspect w}"

        conn |> json(ok(%{}))
    end

    # def add_file_index(conn, %{"metas" => metas}) do
    #     for meta <- metas do
    #         FileMetaRepo.save(meta["id"], meta)
    #     end

    #     conn |> json(ok(%{}))
    # end

    def convert_status(conn, %{"id" => id} = params) do
        w = DfsMaster.Repo.FileMeta.Service.find_by_id(id)
        Logger.info "file: #{inspect Path.basename(__ENV__.file)}  line: #{__ENV__.line}
        #{id}: #{inspect w}"
        case w do
            nil ->
                conn |> json(error(402, "没转好"))
            file_meta ->
                meta_map = Poison.decode! file_meta.meta
                hostname = meta_map["host_name"]

                case StoreManager.lookup(hostname) do
                    nil ->
                        Logger.error "file: #{inspect Path.basename(__ENV__.file)}  line: #{__ENV__.line}
                        #{inspect hostname} 服务未启动，请稍后重试"
                        conn |> json(error(408, "#{inspect hostname} 服务未启动，请稍后重试"))
                    _ ->
                        conn |> json(ok(%{meta: meta_map}))
                end
        end
    end

    def del_file_index(conn, %{"id" => id, "host_name"=>host_name} = params) do
        DfsMaster.Repo.FileMeta.Service.delete_id_on_host_name(id,host_name)
        conn |> json(ok(%{}))
    end

    def get_file_count(conn, params) do
        conn |> json(ok(%{count: :count}))
    end

    def get_upload_url(conn, params) do
        store = StoreManager.get_store

        case store do
            {:ok, store} ->
                conn |> json(ok(store))
            _ ->
                conn |> json(error(500, "没有合适的 store!"))
        end

    end

    def get_all_store(conn, params) do
        conn |> json(ok(%{stores: StoreManager.getAll}))
    end

end
