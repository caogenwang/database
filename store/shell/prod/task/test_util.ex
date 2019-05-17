defmodule Test.Util do
    @lib_path "#{__DIR__}/../../../_build/prod/lib/"

    def init do
        File.ls!(@lib_path) |> Enum.map(&(Code.append_path(@lib_path<>&1<>"/ebin")))
    
        [:httpoison, :admin, :timex, :dengta_faxianzhe]
        |> Enum.map(&(Application.ensure_all_started(&1)))
    end
end

