defmodule Test.Util do
    @lib_path "#{__DIR__}/../../../_build/dev/lib/"

    require Logger

    def init do
        File.ls!(@lib_path) |> Enum.map(&(Code.append_path(@lib_path<>&1<>"/ebin")))

        [:dfs_master]
        |> Enum.map(&(Application.ensure_all_started(&1)))
    end
end

