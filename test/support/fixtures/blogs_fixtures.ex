defmodule RealWorld.BlogsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RealWorld.Blogs` context.
  """

  @doc """
  Generate a article.
  """
  def article_fixture(attrs \\ %{}) do
    {:ok, article} =
      attrs
      |> Enum.into(%{
        body: "some body",
        title: "some title"
      })
      |> RealWorld.Blogs.create_article()

    article
  end
end
