defmodule RealWorld.Blogs.ArticleTag do
  use Ecto.Schema
  import Ecto.Changeset
  alias RealWorld.Blogs.Article
  alias RealWorld.Blogs.Tag

  @primary_key false
  schema "articles_tags" do
    belongs_to :article, Article
    belongs_to :tag, Tag
  end

  @doc false
  def changeset(article_tag, attrs) do
    article_tag
    |> cast(attrs, [:article_id, :tag_id])
    |> validate_required([:article_id, :tag_id])
  end
end
