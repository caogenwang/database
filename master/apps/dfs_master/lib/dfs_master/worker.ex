defmodule DATABASE.Process do
    use GenServer
    # the name of old table
    @table_name "file_metas"
    @logpath "/System/logs"
    require Logger

    def start_link do
      pid = GenServer.start_link(__MODULE__, %{module: __MODULE__}, name: __MODULE__)
    end

    def init(arg) do
      send(self(), {:prcess})
      {:ok, arg}
    end

    def handle_info({:prcess}, state) do
      start()
      {:noreply, state}
    end

    def start() do
      limit = 1000
      data = 1
      page = 1
      day = day_get()
      file_path = "#{@logpath}/data_migtate/#{day}.log"
      last_id = last_id_get(file_path)
      migrate(@table_name, limit, last_id, data,page)
    end

    # 放到新的数据库
    def insert(data) when is_list(data) do
      DfsMaster.Repo.transaction(fn ->
        Enum.map(data, fn item ->
          w = DfsMaster.Repo.FileMeta.Service.insert(%{id: item.id, meta: item.meta})

          case w do
            {:error, _} ->
              HKLogger.log(
                "data_migtate_error",
                "#{HKTime.local_time_str()},#{item.id}"
              )

            {:ok, _} ->
              Logger.warn("data_migtate_ok,id:#{item.id}")
          end
        end)
      end)
    end

    def migrate(table, limit, last_id, data,page) when data == [] do
      Logger.warn("file: #{inspect(Path.basename(__ENV__.file))}  line: #{__ENV__.line}")
    end

    def migrate(table, limit, last_id, data,page) do
      data = DfsMaster.OldRepo.Search.Service.query(table, limit, last_id)

      if data != [] do
        insert(data)
      end

      result = Enum.fetch(data, -1)
      if result != :error do
        {_, last} = result
        last_id = Map.get(last,:id)
        HKLogger.log("data_migtate", "#{HKTime.local_time_str()},limit:#{limit},page:#{page},last_id:#{last_id}")
        migrate(table, limit,last_id,data,page + 1)
      else
        migrate(table, limit,last_id,data,page + 1)
      end
    end

    def last_id_get(path) do
      if File.exists?(path) do
        {data, 0} = System.cmd("tail", ["-n", "5", path])
        data = data
        |> String.split("\n")
        |> Enum.filter(fn str->String.length String.trim(str) end)
        |> List.first

        if data != ""  do
          [last_id] =
            data
            |> String.split(",")
            |> Enum.filter(fn string -> String.contains?(string, "last_id") end)
            |> Enum.map(fn string -> String.split(string,":") end)
            last_id = String.to_integer(Enum.at(last_id,1))
          else
            "76522851"
        end
      else
        "76522851"
      end
    end

    def day_get() do
      Timex.today() |> HKTime.time2str() |> String.slice(0..9)
    end

    # 测试从一个数据库迁移到另一个数据库
    # def test_insert() do
    #   Enum.map(1..5000, fn id ->
    #               meta = %{id: id, host_name: "dfs_store_1"}
    #               w = DfsMaster.Repo.FileMeta.Service.insert(%{"id"=> meta.id, "meta"=> Poison.encode! meta})
    #               Logger.warn "file: #{inspect Path.basename(__ENV__.file)}  line: #{__ENV__.line}
    #               #{inspect w}"
    #           end)
    # end

    # def test_search() do
    #   data = 1
    #   DfsMaster.Repo.FileMeta.Service.test_search(0,1000,1,data)
    #   DfsMaster.Repo.FileMeta.Service.test_search_counts()
    # end

    def handle_info(topic, state) do
      {:noreply, state}
    end

   def terminate(reason, state) do
      Logger.info("file: #{inspect(Path.basename(__ENV__.file))}  line: #{__ENV__.line}
      #{inspect(__MODULE__)} destory reason:#{inspect(reason)}")
      :ok
    end
  end
