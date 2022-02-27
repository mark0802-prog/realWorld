defmodule RealWorld.Repo.Migrations.AddColumnAuthorIdToComments do
  use Ecto.Migration

  def change do
    alter table("comments") do
      add :author_id, references(:users, on_delte: :nothing)
    end

    create index(:comments, [:author_id])
  end
end
