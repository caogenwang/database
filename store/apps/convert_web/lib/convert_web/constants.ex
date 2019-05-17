defmodule ConvertWeb.Constants do
    use Agent
    require Logger

    def start_link() do
        Agent.start_link(fn -> %{} end, name: __MODULE__)
    end

    def set_key(list) do
        Agent.update(__MODULE__, &Map.put(&1, :key, list))
    end

    def get_key() do
        Agent.get(__MODULE__, &Map.get(&1, :key))
    end

    def set_host(host) do
        Agent.update(__MODULE__, &Map.put(&1, :host, host))
    end

    def get_host() do
        Agent.get(__MODULE__, &Map.get(&1, :host))
    end

    def set_server_name(name) do
        Agent.update(__MODULE__, &Map.put(&1, :name, name))
    end

    def get_server_name() do
        Agent.get(__MODULE__, &Map.get(&1, :name))
    end
    
end