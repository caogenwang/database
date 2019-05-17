defmodule DFS_Master.DengtaConfig do
    def dengta_url do
        System.get_env("DENGTA_URL") || raise "expected the {DENGTA_URL} environment variable to be set"
    end

    def dengta_content do
        %{
            type: "dfs_master",
            desp: "dfs_master 服务",
            name: (System.get_env("SERVER_NAME") || raise "expected the {SERVER_NAME} environment variable to be set"),
            url: (System.get_env("SERVER_URL") || raise "expected the {SERVER_URL} environment variable to be set"),
            version: to_string(Application.spec(:convert_web,:vsn))
        }
    end

    def dengta_deps do
        ["dfs_store"]
    end

    def heart_beat_time do
        30_000
    end
end