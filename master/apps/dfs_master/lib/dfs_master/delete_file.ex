defmodule DfsMaster.DeleteFile do

    require Logger

    def deleteFile(new_file_meta,old_file_meta) do
        new_file_meta = Poison.decode! new_file_meta.meta
        old_file_meta = Poison.decode! old_file_meta.meta

        Logger.info "file: #{inspect Path.basename(__ENV__.file)}  line: #{__ENV__.line}
        new_file_meta: #{inspect new_file_meta}"
        Logger.info "file: #{inspect Path.basename(__ENV__.file)}  line: #{__ENV__.line}
        old_file_meta: #{inspect old_file_meta}"

        _deleteFile(new_file_meta,old_file_meta)
    end

    def _deleteFile(%{"host_name"=>host_name},%{"host_name"=>host_name}) do
        Logger.info "file: #{inspect Path.basename(__ENV__.file)}  line: #{__ENV__.line}
        #{inspect :nothing_to_do}"
        :nothing_to_do
    end

    def _deleteFile(new_file_meta,old_file_meta) do
        Task.Supervisor.start_child(DfsMaster.TaskSupervisor, fn ->
            store = StoreManager.get_store(old_file_meta["host_name"])
            deleteFileURL = "#{store["url"]}/del_file/#{old_file_meta["id"]}"
            HTTPoison.get deleteFileURL
            Logger.info "file: #{inspect Path.basename(__ENV__.file)}  line: #{__ENV__.line}
            delete #{old_file_meta["id"]} on #{store["url"]}"
        end)
    end
end
