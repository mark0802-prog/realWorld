defmodule RealWorld.Repo.Migrations.AddColumnAuthorIdToArticles do
  use Ecto.Migration

  def change do
    alter table("articles") do
      add :author_id, references(:users, on_delete: :nothing)
    end

    create index(:articles, [:author_id])
  end
end
