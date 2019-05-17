defmodule DfsMaster.Repo.FileMeta.Service do
    use Ecto.Schema
    import Ecto.Query
    import Ecto.Changeset
    use Timex
    require Logger
    alias DfsMaster.Repo
    alias DfsMaster.Repo.FileMeta

    defp fields do
        %FileMeta{}
        |> Map.drop([:__meta__, :__struct__, :inserted_at, :updated_at])
        |> Map.keys
    end

    def insertChangeset(base, params \\ %{}) do
        base
        |> Ecto.put_meta(source: FileMeta.insertTableNameByID(params.id))
        |> cast(params, fields())
        |> unique_constraint(:id)
        |> validate_required(fields())
        |> validate_exclusion(:meta, ["null"])
    end

    def insert file_meta do
        file_meta = file_meta
        |> HKMap.key2atom
        |> Map.take(fields())

        case find_by_id(file_meta.id) do
            nil  ->
                %FileMeta{}
            post ->
                DfsMaster.DeleteFile.deleteFile(file_meta,post)
                Logger.warn "file: #{inspect Path.basename(__ENV__.file)}  line: #{__ENV__.line}
                #{inspect post}"
                post
        end
        |> insertChangeset(file_meta)
        |> Repo.insert_or_update
    end

    def find do
        from(
          u in FileMeta.queryTableNameByID(0),
          where: true,
          select: u
        )
        |> Repo.all
    end

    def gen_query msg do
        msg
        |> Enum.reduce(FileMeta.queryTableNameByID(0),fn
            # {"id",value},acc->acc |> where([u], like(u.id, ^("%#{value}%")))
            {"id",value},acc->acc |> where([u], u.id == ^value)
            _,acc->acc
        end)
        |> order_by([u], [asc: u.id])
    end

    def find_count msg do
        msg = msg |> Map.drop(["offset","limit"])
        gen_query(msg)
        |> select([u],count(u.id))
        |> Repo.all
        |> List.first
    end

    def find_by_id id do
        Logger.info "file: #{inspect Path.basename(__ENV__.file)}  line: #{__ENV__.line}
        #{inspect 123}"
        from(u in FileMeta.queryTableNameByID(id), where: u.id == ^id, select: u)
        |> Repo.all
        |> List.first
    end

    def delete_id_on_host_name(id,host_name) when is_bitstring(id) do
        delete_id_on_host_name(String.to_integer(id),host_name)
    end

    def delete_id_on_host_name(id,host_name) do
        case find_by_id(id) do
            nil  ->
                {:ok, "id 不存在"}
            post ->
                meta = Poison.decode! post.meta
                if host_name == meta["host_name"] do
                    %FileMeta{id: id} |> Ecto.put_meta(source: FileMeta.insertTableNameByID(id)) |> Repo.delete
                else
                    {:ok, "host_name 不匹配"}
                end
        end
    end

end
