defmodule RealWorld.Blogs.Article do
  use Ecto.Schema
  import Ecto.Changeset
  alias RealWorld.Blogs.Comment
  alias RealWorld.Blogs.Tag
  alias RealWorld.Blogs.ArticleTag
  alias RealWorld.Accounts.User

  schema "articles" do
    field :body, :string
    field :title, :string
    belongs_to :author, User
    has_many :comments, Comment, on_delete: :delete_all
    many_to_many :tags, Tag, join_through: ArticleTag, on_replace: :delete, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(article, attrs, tags \\ []) do
    article
    |> cast(attrs, [:title, :body, :author_id])
    |> validate_required([:title, :body, :author_id])
    |> put_assoc(:tags, tags)
  end
end
