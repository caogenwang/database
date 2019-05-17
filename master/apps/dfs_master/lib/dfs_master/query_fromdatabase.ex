defmodule DfsMaster.OldRepo.Search.Service do#操作获取数据的数据库OldRepo
    use Ecto.Schema
    import Ecto.Query
    import Ecto.Changeset
    use Timex
    require Logger
    alias DfsMaster.OldRepo

    schema "default" do
      field(:meta, :string)
    end

    def queryTableFromOldDatabase(database) do
      %Ecto.Query{from: {"#{database}", __MODULE__}, prefix: (nil)}
    end

    def query(database,limit,last_id) do
      from(
        u in queryTableFromOldDatabase(database),
        where: u.id > ^last_id,
        select: %{id: u.id,meta: u.meta},
        limit: ^limit
      )
      |> OldRepo.all
    end
end
