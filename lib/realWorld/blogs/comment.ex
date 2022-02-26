defmodule RealWorld.Blogs.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias RealWorld.Blogs.Article

  schema "comments" do
    field :body, :string
    belongs_to :article, Article

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:body, :article_id])
    |> validate_required([:body, :article_id])
  end
end
