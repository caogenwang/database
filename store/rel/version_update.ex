require Logger

env = System.get_env("env")
app_name=System.get_env("AppName")
release_path="#{__DIR__}/../_build/#{env}/rel/#{app_name}/releases"

File.mkdir_p!(release_path)
v = File.ls!(release_path)
|> Enum.filter(fn x ->
    case Version.parse(x) do
        {:ok,_} -> true
        _ -> false
    end
end)

oldVersion = ["0.1.0" | v]
|> Enum.sort(fn x1,x2->Version.compare(x1, x2) == :gt end)
|> List.first

newVersion = oldVersion
|> String.split(".")
|> Enum.map(&(String.to_integer(String.trim(&1))))
|> List.update_at(2,fn x->x+1 end)
|> Enum.map(&(to_string(&1)))
|> Enum.join(".")

File.mkdir_p!("#{__DIR__}/../_build/#{env}/")
File.write!("#{__DIR__}/../_build/#{env}/version",newVersion)

Logger.warn "file: #{inspect Path.basename(__ENV__.file)}  line: #{__ENV__.line}
oldVersion: #{inspect oldVersion}"
Logger.warn "file: #{inspect Path.basename(__ENV__.file)}  line: #{__ENV__.line}
newVersion: #{inspect newVersion}"


x = File.ls!("#{__DIR__}/../apps")
|> Enum.map(fn x->Path.join(["#{__DIR__}/../apps",x,"mix.exs"]) end)
|> Enum.map(fn x->
    str = File.read!(x)
    File.write!(x,str)
end)
