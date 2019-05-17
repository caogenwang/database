defmodule DfsMaster.Repo.Migrations.AddFileMetasTable do
  use Ecto.Migration

  def change do
    for x <- 0..10000 do
        create_if_not_exists table("metas_#{x}") do
          add :meta, :string
          timestamps
        end

        create unique_index("metas_#{x}", [:id], name: :id_index)
    end
  end
end
