Code.load_file("test_util.ex", "#{__DIR__}")
Test.Util.init()
require Logger

Logger.warn("file: #{inspect(Path.basename(__ENV__.file))}  line: #{__ENV__.line}
#{System.get_env("STORE")} check start")
store_path = "/Documents"
files = File.ls!(store_path)

defmodule Task.Check do
  require Logger
  @store System.get_env("STORE")
  def run(id) do
    try do
      url = "http://192.168.4.40/dfs_master/api/convert_status?id=#{id}"
      {json, 0} = System.cmd("curl", ["-s", url])

      case Poison.decode!(json) do
        %{"content" => %{"code" => 402, "reason" => "没转好"}, "status" => "error"} ->
          handle_meta(%{"id" => id})

        %{"status" => "ok", "content" => %{"meta" => meta}} ->
          handle_meta(meta)
      end
    rescue
      x ->
        File.write!("#{__DIR__}/error.log", "#{inspect x}\n", [:append])
        x
    end
  end

  # def handle_meta(%{"id" => id, "host_name" => @store, "version" => "1.3.3"} = meta) do
  #   Logger.info("file: #{inspect(Path.basename(__ENV__.file))}  line: #{__ENV__.line}
  #       #{inspect(meta)}")
  # end

  def handle_meta(%{"id" => id} = meta) do
    Logger.warn("file: #{inspect(Path.basename(__ENV__.file))}  line: #{__ENV__.line}
        #{inspect(meta)}")
    url = "http://192.168.4.40/convert_master/api/start_convert?id=#{id}&format=#{meta["format"]}"
    {json, 0} = System.cmd("curl", ["-s", url])

    url = "http://192.168.4.40/#{@store}/del_file/#{id}?immediately=1"
    {json, 0} = System.cmd("curl", ["-s", url])
  end

  def handle_meta(meta) do
    Logger.error("file: #{inspect(Path.basename(__ENV__.file))}  line: #{__ENV__.line}
        #{inspect(meta)}")
  end
end

total = length(files)
Logger.warn("file: #{inspect(Path.basename(__ENV__.file))}  line: #{__ENV__.line}
#{inspect(total)}")

Process.sleep(5000)

files
|> Enum.reduce(0, fn file, acc ->
  id = Path.basename(file, ".zip")
  Task.Check.run(id)

  File.write!("#{__DIR__}/#{System.get_env("STORE")}.log", "#{acc}/#{total}\n", [:append])
  acc + 1
end)

File.write!("#{__DIR__}/#{System.get_env("STORE")}.log", "#{System.get_env("STORE")} end\n", [:append])
Logger.warn("file: #{inspect(Path.basename(__ENV__.file))}  line: #{__ENV__.line}
check end")


