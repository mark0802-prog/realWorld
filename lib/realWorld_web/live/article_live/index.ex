defmodule RealWorldWeb.ArticleLive.Index do
  use RealWorldWeb, :live_view

  alias RealWorld.Blogs
  alias RealWorld.Blogs.Article
  alias RealWorld.Accounts

  @impl true
  def mount(_params, session, socket) do
    token = session["user_token"] || ""
    current_user = Accounts.get_user_by_session_token(token)

    {
      :ok,
      socket
      |> assign(:articles, list_articles())
      |> assign(:current_user, current_user)
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Article")
    |> assign(:article, Blogs.get_article!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Article")
    |> assign(:article, %Article{author_id: socket.assigns.current_user.id})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Articles")
    |> assign(:article, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    article = Blogs.get_article!(id)
    {:ok, _} = Blogs.delete_article(article)

    {:noreply, assign(socket, :articles, list_articles())}
  end

  defp list_articles do
    Blogs.list_articles()
  end
end
