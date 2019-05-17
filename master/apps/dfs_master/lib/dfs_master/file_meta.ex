defmodule DfsMaster.Repo.FileMeta do
    use Ecto.Schema

    schema "default" do
        field(:meta, :string)
    end

    def insertTableNameByID(id) do
        id = div(String.to_integer("#{id}"), 10_000_000_000)
        "metas_#{id}"
    end

    def queryTableNameByID(id) do
        id = div(String.to_integer("#{id}"), 10_000_000_000)
        %Ecto.Query{from: {"metas_#{id}", __MODULE__}, prefix: (nil)}
    end
end
