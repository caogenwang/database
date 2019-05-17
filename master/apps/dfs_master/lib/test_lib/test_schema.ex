defmodule DfsMaster.Repo.Worker do
  use Ecto.Schema
  schema "worker" do
    field(:name, :string)
    field(:age, :integer)
    field(:work, :string)
    field(:home, :string)
    timestamps()
  end

  def queryTableFromOldDatabase(database) do
    %Ecto.Query{from: {"#{database}", __MODULE__}, prefix: (nil)}
  end


  defmodule Service do

    import Ecto.Query
    import Ecto.Changeset
    alias DfsMaster.Repo
    alias DfsMaster.Repo.Worker, as: Worker
    require Logger
    @tables_0 "test_0"
    @tables_1 "test_1"

    def client_fields do
      %Worker{}
      |> Map.drop([:__meta__, :__struct__])
      |> Map.keys()
    end

    def fields do
      %Worker{}
      |> Map.drop([:__meta__, :__struct__, :inserted_at, :updated_at, :id])
      |> Map.keys()
    end

    def insertChangeset(base, params \\ %{}) do

      Ecto.put_meta(base,source: @tables_0)
      |>  cast(params, fields())
      |>  unique_constraint(:name)
      |>  validate_required(fields())
      |>  validate_exclusion(:name, ["null"])

    end

    def insert(entry) do
        entry = entry
        |> HKMap.key2atom()
        |> Map.take(fields())

        case find_entry_by_name(entry.name) do
          nil -> %Worker{}
          post ->
            # DfsMaster.DeleteFile.deleteFile(file_meta,post)
            # Logger.warn "file: #{inspect Path.basename(__ENV__.file)}  line: #{__ENV__.line}
            # #{inspect post}"
            post
        end

        |> insertChangeset(entry)
        |> Repo.insert_or_update()
    end

    def process() do

      Logger.warn "struct:#{inspect %Worker{}}"
      # list =[
      #           %{"name"=>"zhu","age"=>"70","work"=>"leader","home"=>"an hui"},
      #           %{"name"=>"wang","age"=>"70","work"=>"leader","home"=>"an hui"},
      #           %{"name"=>"liu","age"=>"70","work"=>"leader","home"=>"an hui"},
      #           %{"name"=>"huang","age"=>"70","work"=>"leader","home"=>"an hui"},
      #           %{"name"=>"jin","age"=>"70","work"=>"leader","home"=>"an hui"}
      #       ]

      # Enum.map(list, fn data ->
      #           res = insert(data)
      #           Logger.warn "res: #{inspect res}"
      #         end)
      data = query_join()
      Logger.warn "data:#{inspect data}"
    end

    def find(name) do
      data = find_entry_by_name(name)
    end

    def delete(name,id) do
      data = find(name)
      delete(data.id)
    end

    def delete(id) when is_number(id) do#id 默认问主键，所以需要直接根据主键删除

      Ecto.put_meta(%Worker{},source: @tables_0)
      |> Map.put(:id, id)
      |> Repo.delete()
    end


    def find_entry_by_name(name) do
      from(u in Worker.queryTableFromOldDatabase(@tables_0), where: u.name == ^name, select: u)
      |> Repo.all
      |> List.first
    end

    def query() do
      from(
        u in Worker.queryTableFromOldDatabase(@tables_0),
        where: true,
        select: u
      )
      |> Repo.all
    end

    def query_join() do
      test_0 = Worker.queryTableFromOldDatabase(@tables_0)
      test_1 = Worker.queryTableFromOldDatabase(@tables_1)
      from(
        u in test_0,
        right_join: p in ^test_1,
        # on: u.id == p.id,
        where: true,
        # select: {u.id,p.id}
      )
      |> Repo.all
    end

  end#Service

end#Worker
