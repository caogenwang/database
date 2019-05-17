defmodule StoreManager do
  require Logger
  alias Entice.Entity

  @max_percent 88

  def getAll() do
    list = DengtaFaxianzhe.find_by_type("dfs_store")
        |> Enum.map(fn %{"info"=>info, "name" => name,"update_at"=>update_at} ->
            msg = info |> Map.put("name", name)
            msg |> Map.put("update_at", update_at)
        end)

        # 计算 total
        run_info = list
        |> Enum.reduce(%{"total_page_1_request"=>0,"total_files"=>0,"total_page_request"=>0},
        fn %{"run_info"=>run_info},acc->
            %{
                "total_page_1_request"=>acc["total_page_1_request"] + run_info["total_page_1_request"],
                "total_files"=>acc["total_files"] + run_info["total_files"],
                "total_page_request"=>acc["total_page_request"] + run_info["total_page_request"]
            }
        end)

        disk_info = list
        |> Enum.reduce(%{"used"=>"0","total"=>"0","percent"=>0,"free"=>"0"},
        fn %{"disk_info"=>disk_info},acc->
        total = String.to_integer(acc["total"])+String.to_integer(disk_info["total"])
        free = String.to_integer(acc["free"])+String.to_integer(disk_info["free"])
        percent = 100 - div(free * 100, total)
            %{
                "used"=>to_string(String.to_integer(acc["used"])+String.to_integer(disk_info["used"])),
                "total"=>to_string(String.to_integer(acc["total"])+String.to_integer(disk_info["total"])),
                "percent"=>percent,
                "free"=>to_string(String.to_integer(acc["free"])+String.to_integer(disk_info["free"]))
            }
        end)

        ret = [%{"name"=>"total","run_info"=>run_info,"disk_info"=>disk_info} | list]

        ret = ret
        |> Enum.map(fn v->
            disk_info = v["disk_info"]
            disk_info = disk_info
            |> Map.put("used",h_size(String.to_integer(disk_info["used"])))
            |> Map.put("total",h_size(String.to_integer(disk_info["total"])))
            |> Map.put("free",h_size(String.to_integer(disk_info["free"])))
            |> Map.put("percent", to_string(disk_info["percent"])<>"%")
            v |> Map.put("disk_info",disk_info)
            |> Map.take(["disk_info","run_info","name","update_at"])
        end)
  end

  defp h_size(size) when size > 1024 * 1024 * 1024 * 1024, do: (Float.round(size / (1024 * 1024 * 1024 * 1024),2) |> Float.to_string)<>"P"
  defp h_size(size) when size > 1024 * 1024 * 1024, do: (Float.round(size / (1024 * 1024 * 1024),2) |> Float.to_string)<>"T"
  defp h_size(size) when size > 1024 * 1024, do: (Float.round(size / (1024 * 1024),2) |> Float.to_string)<>"G"
  defp h_size(size) when size > 1024, do: (Float.round(size / (1024),2) |> Float.to_string)<>"M"
  defp h_size(size), do: (Integer.to_string(size))<>"K"

  def lookup(name) do
    DengtaFaxianzhe.find({"dfs_store",name})
  end

  def get_store do
    stores = DengtaFaxianzhe.find_by_type("dfs_store")
    |> Enum.map(fn %{"info"=>info, "name" => name,"update_at"=>update_at} ->
      msg = info |> Map.put("name", name)
      msg |> Map.put("update_at", update_at)
    end)
    |> Enum.filter(fn
        %{"disk_info" => %{"percent" => percent},"update_at" => update_at} ->
          Timex.before?(Timex.shift(Timex.now, minutes: -3), Timex.from_unix(update_at))
            and (percent < @max_percent)
        _ ->
            false
    end)

    reply = case length(stores) do
        0 ->
            Logger.error "file: #{inspect Path.basename(__ENV__.file)}  line: #{__ENV__.line}
            严重警告，没有合适的store来存储文件"
            {:error, :not_found}
        _ ->
            {:ok, Enum.random(stores)}

    end
  end

  def get_store(name) do
    DengtaFaxianzhe.find({"dfs_store",name})
  end

end
