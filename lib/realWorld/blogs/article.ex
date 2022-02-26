defmodule RealWorld.Blogs.Article do
  use Ecto.Schema
  import Ecto.Changeset
  alias RealWorld.Blogs.Comment
  alias RealWorld.Blogs.Tag
  alias RealWorld.Blogs.ArticleTag

  schema "articles" do
    field :body, :string
    field :title, :string
    has_many :comments, Comment, on_delete: :delete_all
    many_to_many :tags, Tag, join_through: ArticleTag, on_replace: :delete, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(article, attrs, tags \\ []) do
    article
    |> cast(attrs, [:title, :body])
    |> validate_required([:title, :body])
    |> put_assoc(:tags, tags)
  end
end
