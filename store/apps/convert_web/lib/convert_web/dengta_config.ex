defmodule DFS_Store.DengtaConfig do
    def dengta_url do
        System.get_env("DENGTA_URL") || raise "expected the {DENGTA_URL} environment variable to be set"
    end

    def dengta_content do
        %{
            type: "dfs_store",
            desp: "dfs_store 服务",
            name: (System.get_env("SERVER_NAME") || raise "expected the {SERVER_NAME} environment variable to be set"),
            url: (System.get_env("SERVER_URL") || raise "expected the {SERVER_URL} environment variable to be set"),
            version: to_string(Application.spec(:convert_web,:vsn)),
            info: %{
                action: %{
                  upload: "#{System.get_env("SERVER_URL")}/send_file"
                },
                disk_info: HKDiskInfo.getDiskInfo,
                run_info: %{
                  total_files: Store.totalCount,
                  total_page_1_request: -1,
                  total_page_request: -1
                }
              }
        }
    end

    def dengta_deps do
        ["dfs_master"]
    end

    def heart_beat_time do
        30_000
    end
end
