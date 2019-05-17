Code.load_file("test_util.ex","#{__DIR__}/../")
Test.Util.init

require Logger

defmodule AdminWeb.PageControllerTest do
    use DfsMaster.DataCase

    alias DfsMaster.Repo.FileMeta.Service

    require Logger

    test "插入" do
        # w = Ecto.Queryable.to_query("dfs_master.meta_0")
        # Logger.warn "file: #{inspect Path.basename(__ENV__.file)}  line: #{__ENV__.line}
        # #{inspect w}"
        meta = %{id: 2, host_name: "dfs_store_1"}
        w = Service.insert(%{"id"=> meta.id, "meta"=> Poison.encode! meta})
        Logger.warn "file: #{inspect Path.basename(__ENV__.file)}  line: #{__ENV__.line}
        #{inspect w}"

        w = Service.find_by_id(meta.id)
        Logger.warn "file: #{inspect Path.basename(__ENV__.file)}  line: #{__ENV__.line}
        #{inspect w}"

        w = Service.find_by_id(meta.id)
        Logger.warn "file: #{inspect Path.basename(__ENV__.file)}  line: #{__ENV__.line}
        #{inspect w}"

        w = Service.delete_id_on_host_name(2, "dfs_store_1")
        Logger.info "file: #{inspect Path.basename(__ENV__.file)}  line: #{__ENV__.line}
        #{inspect w}"

        w = Service.find_by_id(meta.id)
        Logger.warn "file: #{inspect Path.basename(__ENV__.file)}  line: #{__ENV__.line}
        #{inspect w}"
    end

    # test "删除" do
    #     meta = %{id: 1, host_name: "dfs_store_1"}
    #     w = Service.insert(%{"id"=> "1", "meta"=> Poison.encode! meta})
    #     Logger.warn "file: #{inspect Path.basename(__ENV__.file)}  line: #{__ENV__.line}
    #     #{inspect w}"

    #     w = Service.find
    #     Logger.warn "file: #{inspect Path.basename(__ENV__.file)}  line: #{__ENV__.line}
    #     #{inspect w}"

    #     {:ok, "id 不存在"} = Service.delete_id_on_host_name(123123, "dfs_store")
    #     {:ok, "host_name 不匹配"} = Service.delete_id_on_host_name(1, "dfs_store")
    #     {:ok, _} = Service.delete_id_on_host_name(1, "dfs_store_1")
    #     {:ok, _} = Service.delete_id_on_host_name("1", "dfs_store_1")
    # end
end
