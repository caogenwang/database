defmodule DfsMaster.Repo.Migrations.AddFileMetasTable do
  use Ecto.Migration

  def change do
    for x <- 0..10 do
        create_if_not_exists table("metas_#{x}") do
          add :meta, :string
          timestamps
        end
    end


    # create unique_index(:file_metas, [:id], name: :id_index)
    # create unique_index(:file_metas, [:id])
  end
end
