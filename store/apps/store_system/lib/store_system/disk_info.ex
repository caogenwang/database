defmodule HKDiskInfo do
    require Logger

    def getDiskInfo do
        {x,0} = System.cmd("df",[])
        String.split(x,"\n")
        |> Enum.filter(fn x->
            String.length(x) > 0
        end)
        |> List.delete_at(0)
        |> parseCmd
        |> Enum.filter(fn
            {"/System",v}->
                true
            {"/Documents",v}->
                true
            _->
                false
        end)
        |> Enum.map(fn {k,v}->v end)
        |> List.first

    end

    def parseCmd cmds do
        cmds
        |> Enum.map(fn cmd->
            cmd = String.split(cmd)
            {
                List.last(cmd),
                %{
                    total: Enum.at(cmd,1),
                    used:  Enum.at(cmd,2),
                    free:  Enum.at(cmd,3),
                    percent: String.to_integer(String.trim(Enum.at(cmd,4),"%"))
                }
            }
        end)
        |> Enum.into(%{})
    end
end
