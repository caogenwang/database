defmodule Store do
    require Logger

    @documents "/Documents"

    def get_dir(id) do
        "#{@documents}/#{id}"
    end

    def totalCount do
        length(File.ls!(@documents))
    end
end
