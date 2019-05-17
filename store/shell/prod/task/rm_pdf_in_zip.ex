require Logger

defmodule PDF.Remove do
  @file_path "/Documents"
  @log_path "#{__DIR__}/#{System.get_env("STORE")}.log"
  
  def run() do
    log_list =
      @file_path
      |> File.ls!()
      |> Enum.filter(fn name -> String.contains?(name, ".zip") end)

    sum = Enum.count(log_list)

    log_list
    |> Enum.reduce(1, fn name, acc ->
      id = remove(name)
      File.write!(@log_path, "process: #{acc}/#{sum},id: #{id}\n", [:append])
      acc + 1
    end)
  end

  def remove(name) do
    no_zip_name = List.first(String.split(name, "."))

    result =
      System.cmd("zip", ["-d", Path.join([@file_path, name]), "#{no_zip_name}/#{no_zip_name}.pdf"])

    no_zip_name
  end
end

what = PDF.Remove.run()
# Logger.info("what: #{inspect(what)}")
